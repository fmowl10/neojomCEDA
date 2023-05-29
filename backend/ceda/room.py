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
        moderator_uuid = new_room.join(role=user.Role.MODERATOR)
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
            pass
        new_user = user.User(user.Role.NONE)
        if role == user.Role.LISTENER:
            new_user = user.Listener()
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

    async def count_vote(self) -> dict[str, int]:
        positive_count, negative_count = 0, 0
        for k,v in self.joined_users.items():
            if k == user.Role.LISTENER:
                if v.voted_side == user.Role.NEGATIVE_SPEAKER1:
                    negative_count+=1
                elif v.voted_side == user.Role.POSITIVE_SPEAKER1:
                    positive_count+=1
        return {"positive_count": positive_count, "negative_count": negative_count}

    async def next_state(self):
        pass
    
    async def prev_state(self):
        pass
