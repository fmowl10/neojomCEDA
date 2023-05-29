import asyncio
from typing import AsyncIterator, Awaitable, Generator, AsyncGenerator, Any
import ceda.user as user

class State:
    """토론 진행 상황
    """

    def __init__(self, arguer: user.Role, defender: user.Role, kind: str, time_limit: float) -> None:
        self._defender: user.Role = defender
        self._arguer: user.Role = arguer
        self._time_limit: float = time_limit
        self._kind: str = kind
    
    @property
    def arguer(self) -> user.Role:
        return self._arguer

    @property
    def defender(self) -> user.Role:
        return self._defender
    
    @property
    def time_limit(self) -> float:
        return self._time_limit
    
    @property
    def kind(self) -> str:
        return self._kind


class StateGenerator:
    """토론 진행 단계 진행 제너레이터
    """

    def __init__(self) -> None:
        self._state_list: list[State] = [
            State(user.Role.NONE, user.Role.NONE, "대기", 60),
            State(user.Role.POSITIVE_SPEAKER1, user.Role.NONE, "입론", 6*60),
            State(user.Role.NEGATIVE_SPEAKER2, user.Role.POSITIVE_SPEAKER1, "교차조사", 3*60),
            State(user.Role.NEGATIVE_SPEAKER1, user.Role.NONE, "입론", 6*60),
            State(user.Role.POSITIVE_SPEAKER1, user.Role.NEGATIVE_SPEAKER1, "교차조사", 3*60),
            State(user.Role.POSITIVE_SPEAKER2, user.Role.NONE, "입론", 6*60),
            State(user.Role.NEGATIVE_SPEAKER1, user.Role.POSITIVE_SPEAKER2, "교차조사", 3*60),
            State(user.Role.NEGATIVE_SPEAKER2, user.Role.NONE, "입론", 6*60),
            State(user.Role.POSITIVE_SPEAKER2, user.Role.NEGATIVE_SPEAKER2, "교차조사", 3*60),
            State(user.Role.NEGATIVE_SPEAKER1, user.Role.NONE, "반론", 4*60),
            State(user.Role.POSITIVE_SPEAKER1, user.Role.NONE, "반론", 4*60),
            State(user.Role.NEGATIVE_SPEAKER2, user.Role.NONE, "반론", 4*60),
            State(user.Role.POSITIVE_SPEAKER2, user.Role.NONE, "반론", 4*60),
        ] # TODO: fill State http://www.realdebate.co.kr/ceda%ED%86%A0%EB%A1%A0-%ED%98%95%EC%8B%9D/
        self._current = 0
    
    @property
    def current_state(self) -> State:
        return self._state_list[self._current]

    def next_state(self) -> None:
        self._current += 1
        if self._current >= len(self._state_list):
            raise IndexError("State Out of index")
        return self.current_state
    
    def prev_state(self) -> None:
        self._current -= 1
        if self._current < 0:
            raise IndexError("State Out of index")
        return self.current_state
        
    def insert_breaktime(self, duration:float) -> None:
        self._state_list.insert(self._current+1, State(user.Role.NONE, user.Role.NONE, "휴식", duration))