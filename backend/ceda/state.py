import asyncio
from typing import AsyncIterator, Awaitable, Generator, AsyncGenerator, Any
import user

class State:

    def __init__(self, role: user.Role, kind: str, time_limit: float) -> None:
        self._role: user.Role = role
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

    def __init__(self) -> None:
        self._state_list: list[State] = [] # TODO: fill State
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