import asyncio
from typing import AsyncIterator, Awaitable, Generator, AsyncGenerator, Any
import user

class State:
    """토론 진행 상황
    """

    def __init__(self, arguer: user.Role, defender: user.Role, kind: str, time_limit: float) -> None:
        self._defender: user.Role = defender
        self._arguer: user.Role = arguer
        self._time_limit: float = time_limit
        self._kind: str = kind
    
    @property
    def role(self):
        return self._role
    
    @property
    def time_limit(self):
        return self._time_limit
    
    @property
    def kind(self):
        return self._kind


class StateGenerator(Generator, AsyncGenerator):
    """토론 진행 단계 진행 제너레이터
    """

    def __init__(self) -> None:
        self._state_list: list[State] = [State(user.Role.NEGATIVE_SPEAKER1, user.Role.None, "입론", 6*60), 
                                         ] # TODO: fill State http://www.realdebate.co.kr/ceda%ED%86%A0%EB%A1%A0-%ED%98%95%EC%8B%9D/
        self._current = 0

    def __iter__(self) -> Generator:
        return self
    
    def __next__(self) -> Any:
        if self._current >= len(self._state_list):
            raise StopIteration
        ret = self._state_list[self._current]
        self._current+=1
        return ret

    async def __aiter__(self) -> AsyncIterator:
        return self
    
    async def __anext__(self) -> Awaitable:
        if self._current >= len(self._state_list):
            raise StopIteration
        ret = self._state_list[self._current]
        self._current+=1
        return ret
    
    @property
    def current_state(self):
        return self._state_list[self._current]

    def next_state(self):
        self._current += 1
    
    def prev_state(self):
        self._current -= 1
        
    def insert_breaktime(self, duration:float):
        self._state_list.insert(self._current+1, State(user.Role.NONE, user.Role.NONE, "Break Time", duration))