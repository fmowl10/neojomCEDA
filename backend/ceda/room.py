import asyncio
import user

class RoomManager:
    def __init__(self) -> None:
        self._rooms = dict()

    async def create_room(self, topic:str) -> tuple[int]:
        """새로운 토론방 생성

        Args:
            topic (str): 토론 주제

        Returns:
            tuple[int]: 생성된 방 ID
        """
        new_room_id = len(self._rooms)
        new_room = Room(topic)
        self._rooms[new_room_id] = new_room
    
    async def join_room(self, room_id: int, role: user.Role) -> int:
        if room_id not in self._rooms:
            return -1
        # TODO 참여 가능 여부 확인 필요
        pass


class Room:
    def __init__(self, topic:str) -> None:
        self.joined_users: dict[user.Role, user.User] = dict()
        self.topic = topic
    
    async def join(self, role: user.Role):
        pass
