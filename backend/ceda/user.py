import asyncio
import enum

class Role(enum.Enum):
    MODERATOR=0
    POSITIVE_PARTICIPANT_1=1
    POSITIVE_PARTICIPANT_2=2
    NEGATIVE_PARTICIPANT_1=3
    NEGATIVE_PARTICIPANT_2=4
    GUEST=5

class User:
    def __init__(self, role:Role = Role.GUEST) -> None:
        self.role = role
        pass