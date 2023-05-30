import asyncio
import enum
import uuid

class Role(enum.Enum):
    MODERATOR=0
    POSITIVE_SPEAKER1=1
    POSITIVE_SPEAKER2=2
    NEGATIVE_SPEAKER1=3
    NEGATIVE_SPEAKER2=4
    LISTENER=5
    NONE=6

class User:
    """User 공통 부모 클래스
    """
    def __init__(self, role:Role = Role.LISTENER) -> None:
        self.role = role
        self.uuid = uuid.uuid4()
        pass

class Moderator(User):
    """관리자
    """
    def __init__(self) -> None:
        super().__init__(role=Role.MODERATOR)
        pass

class Listener(User):
    """청중
    """
    def __init__(self) -> None:
        super().__init__(role=Role.LISTENER)
        self.voted_side: Role = Role.NONE # 기본적은 투표없음
    
    def vote(self, vote_to: Role):
        """청중 투표

        Args:
            vote_to (Role): 투표 진영

        Raises:
            ValueError: POSITIVE_SPEAKER, NEGATIVE_SPEAKER가 아닌 경우
        """
        if vote_to not in  [Role.POSITIVE_SPEAKER1, Role.NEGATIVE_SPEAKER1]:
            raise ValueError("Can only vote to positive or negative")
        self.voted_side = vote_to


class PositiveSpeaker1(User):
    """찬성측 발언자
    """
    def __init__(self) -> None:
        super().__init__(role=Role.POSITIVE_SPEAKER1)

class PositiveSpeaker2(User):
    """찬성측 발언자
    """
    def __init__(self) -> None:
        super().__init__(role=Role.POSITIVE_SPEAKER2)

class NegativeSpeaker1(User):
    """반대측 발언자
    """
    def __init__(self) -> None:
        super().__init__(role=Role.NEGATIVE_SPEAKER1)

class NegativeSpeaker2(User):
    """반대측 발언자
    """
    def __init__(self) -> None:
        super().__init__(role=Role.NEGATIVE_SPEAKER2)