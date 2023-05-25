import asyncio
import enum

class Role(enum.Enum):
    MODERATOR=0
    POSITIVE_PARTICIPANT=1
    NEGATIVE_PARTICIPANT=2
    LISTENER=3

class User:
    def __init__(self, role:Role = Role.LISTENER) -> None:
        self.role = role
        pass

class Moderator(User):
    def __init__(self) -> None:
        super().__init__(role=Role.MODERATOR)
        pass

class Listener(User):
    def __init__(self) -> None:
        super().__init__(role=Role.LISTENER)
        pass

class PositiveParticipant(User):
    def __init__(self) -> None:
        super().__init__(role=Role.POSITIVE_PARTICIPANT)

class NegativeParticipant(User):
    def __init__(self) -> None:
        super().__init__(role=Role.NEGATIVE_PARTICIPANT)