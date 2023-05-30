import asyncio
import ceda.user as user
import ceda.state as state
import ceda.ceda_timer as ceda_timer
import time

class RoomManager:
    """토론 방 관리 클래스
    """
    def __init__(self) -> None:
        self._rooms = dict()

    async def create_room(self, topic:str) -> tuple[int, str]:
        """새로운 토론방 생성

        Args:
            topic (str): 토론 주제

        Returns:
            tuple[int]: 생성된 방 ID
        """
        new_room_id = len(self._rooms)
        new_room = Room(topic, new_room_id)
        moderator_uuid = await new_room.join(role=user.Role.MODERATOR)
        self._rooms[new_room_id] = new_room
        return (new_room_id, moderator_uuid)
    
    async def join_room(self, room_id: int, role: user.Role) -> str:
        if room_id not in self._rooms:
            return -1
        room = await self.get_room(room_id)
        user_uuid = room.join(role)
        return str(user_uuid)

    async def get_room(self, room_id: int) -> 'Room':
        return self._rooms[room_id]

class Room:
    """토론 방 정보 추적 클래스
    """
    def __init__(self, topic:str, room_id: int) -> None:
        """토론 방 생성

        Args:
            topic (str): 토론 주제
        """
        self.joined_users: dict[user.Role, user.User] = dict()
        self.joined_listeners: list[user.Listener] = list()
        self.topic = topic
        self.state_generator = state.StateGenerator()
        self.timer = ceda_timer.Timer()
        self.room_id = room_id
    
    async def join(self, role: user.Role) -> str:
        """방에 참가

        Args:
            role (user.Role): 참가 역할

        Returns:
            str: 참가 UUID
        """
        if role in self.joined_users:
            raise ValueError(f"{role} Already Exists")
        new_user = user.User(user.Role.NONE)
        if role == user.Role.LISTENER:
            new_user = user.Listener()
            self.joined_listeners.append(new_user)
            return str(new_user.uuid)
        elif role == user.Role.NEGATIVE_SPEAKER1:
            new_user = user.NegativeSpeaker1()
        elif role == user.Role.NEGATIVE_SPEAKER2:
            new_user = user.NegativeSpeaker2()
        elif role == user.Role.POSITIVE_SPEAKER1:
            new_user = user.PositiveSpeaker1()
        elif role == user.Role.POSITIVE_SPEAKER2:
            new_user = user.PositiveSpeaker2()
        elif role == user.Role.MODERATOR:
            new_user = user.Moderator()
        self.joined_users[role] = new_user
        return str(new_user.uuid)

    async def vote(self, uuid: str, role: user.Role):
        for listener in self.joined_listeners:
            if str(listener.uuid) == uuid:
                listener.vote(role)

    async def count_vote(self) -> dict[str, int]:
        positive_count, negative_count = 0, 0
        for listener in self.joined_listeners:
            if listener.voted_side == user.Role.POSITIVE_SPEAKER1:
                positive_count+=1
            elif listener.voted_side == user.Role.NEGATIVE_SPEAKER1:
                negative_count += 1
        return {"positive": positive_count, "negative": negative_count}

    async def next_state(self):
        new_state: state.State = self.state_generator.next_state()
        await self.timer.stop_timer()
        await self.timer.set_duration(new_state.time_limit)

    async def prev_state(self):
        new_state = self.state_generator.prev_state()
        await self.timer.set_duration(new_state.time_limit)

    async def current_state(self):
        current_state = self.state_generator.current_state
        return {
            "kind": current_state.kind, 
            "time_left": await self.timer.get_remain_time(),
            "is_finished": self.timer.finished,
            "timer_state": (await self.timer.get_state()).name,
            "arguer": current_state.arguer.name,
            "defender": current_state.defender.name
        }