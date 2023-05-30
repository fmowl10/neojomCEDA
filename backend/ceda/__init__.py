# ceda backend server package

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import ceda.room as room
import ceda.user as user
import ceda.ceda_timer as ceda_timer

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"]
)
room_manager = room.RoomManager()


@app.get("/create")
async def create_room(topic: str):
    """토론방 생성
        생성된 방 번호와, MODERATOR의 UUID 보내줌
    """
    room_id, moderator_uuid = await room_manager.create_room(topic)
    room = await room_manager.get_room(room_id)
    await room.timer.set_duration(room.state_generator.current_state.time_limit)
    return {"room_id": room_id, "uuid": moderator_uuid}


@app.get("/{room_id}/join")
async def join_room(room_id: int, role: str):
    """
    /{room_id}/join?role=str
    사용자가 room_id에 들어갈때 사용되는 ID
    사용자 역할이 중복되는 경우 409로 반환됨

    생성된 사용자 UUID 반환
    """
    try:
        room = await room_manager.get_room(room_id)
        uuid = await room.join(user.Role[role.upper()])
        return {"uuid": uuid}
    except Exception as e:
        print(e)
        raise HTTPException(409, f"{e}")


@app.get("/{room_id}/state")
async def room_state(room_id: int):
    """
    /{room_id}/state
    현재 발언자, 방어자, 발언형태, 시간등을 남깁니다.
    {
        ["argure":,]
        ["defender",]
        "kind":,
        "time_left":,
        "is_finnished": 
    }
    """
    # 활동하는사람, 단계, 타이머 남은시간
    room = await room_manager.get_room(room_id)
    state = await room.current_state()
    return state


@app.get("/{room_id}/break_time")
async def insert_breaktime(room_id: int, duration: int, uuid: str):
    """
    /{room_id}/state?uuid= &duration=
    쉬는 시간을 추가하는 명령
    response
    {
        "result" : "ok"
    }
    """
    room = await room_manager.get_room(room_id)
    room.state_generator.insert_breaktime(duration)
    return {"result": "ok"}


@app.get("/{room_id}/next")
async def next(room_id: int, uuid: str):
    """
    /{user_id}/next?uuid=str
    차례를 다음으로 넘깁니다.
    response
    {
        "result" : "ok"
    }
    """
    room = await room_manager.get_room(room_id)
    try:
        await room.next_state()
    except Exception as e:
        raise HTTPException(406, f"{e}")
    return {"result": "ok"}


@app.get("/{room_id}/prev")
async def prev(room_id: int, uuid: str):
    """
    /{user_id}/prev?uuid=str
    차례를 이전으로 넘깁니다.
    response
    {
        "result" : "ok"
    }
    """
    room = await room_manager.get_room(room_id)
    try:
        await room.prev_state()
    except Exception as e:
        raise HTTPException(406, f"{e}")
    return {"result": "ok"}


@app.get("/{room_id}/start")
async def start(room_id: int, uuid: str, reset: bool = False):
    """
    /{room_id}/start?uuid=&reset=false
    타이머 시작
    response
    {
        "result": "ok"
    }
    """
    room = await room_manager.get_room(room_id)
    if await room.timer.get_state() == ceda_timer.TimerState.PAUSED and not reset:
        await room.timer.resume_timer()
    else:
        await room.timer.set_duration(room.state_generator.current_state.time_limit)
        await room.timer.start_timer()
    return {"result": "ok"}


@app.get("/{room_id}/pause")
async def pause(room_id: int, uuid: str):
    """
    /{room_id}/pause?uuid=&reset=false
    타이머 일시정지
    response
    {
        "result": "ok"
    }
    """
    room = await room_manager.get_room(room_id)
    await room.timer.pause_timer()
    return {"result": "ok"}


@app.get("/{room_id}/restart")
async def restart(room_id: int, uuid: str):
    """
    /{room_id}/restart?uuid=
    """
    room = await room_manager.get_room(room_id)
    await room.timer.stop_timer()
    return {"result": "ok"}


@app.get("/{room_id}/poll")
async def poll(room_id: int, uuid: str, positive: bool):
    """
    /{user_id}/poll?uuid=str&positive=bool
    차례를 이전으로 넘깁니다.
    response
    {
        "result" : "ok"
    }
    """
    room = await room_manager.get_room(room_id)
    await room.vote(uuid, user.Role.POSITIVE_SPEAKER1 if positive else user.Role.NEGATIVE_SPEAKER1)
    return {"result": "ok"}


@app.get("/{room_id}/poll-result")
async def poll(room_id: int):
    """
    /{room_id}/poll-result
    현재 투표결과 받는 end_point
    response
    {
        "positive" : N,
        "negative" : N
    }
    """
    room = await room_manager.get_room(room_id)
    return await room.count_vote()
