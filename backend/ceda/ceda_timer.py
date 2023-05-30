from time import time
import enum
import asyncio

class TimerState(enum.Enum):
    READY=0
    RUNNING=1
    PAUSED=2
    STOPPED=3

class Timer:
    """타이머
    """
    def __init__(self) -> None:
        self.duration = 0.0
        self.remain = 0.0
        self.finished = True
        self._timer_task: asyncio.Task = None
        self._paused = False
        self._stop = False

    async def _timer(self):
        """타이머 내부 테스크

        0.1초 단위로 시간 감소 남은시간이 0이되면 타이머 상태를 Finished로 바꿈
        """
        current_time = time()
        while not self._stop and self.remain > 0:
            await asyncio.sleep(0.1)
            if not self._paused:
                self.remain -= time() - current_time
                if self.remain < 0:
                    self.remain = 0
                    break
            current_time = time()
        self.finished = True

    async def get_remain_time(self) -> float:
        """타이머 남은시간"""
        return self.remain

    async def start_timer(self):
        """타이머 시작"""
        if self._timer_task is not None:
            # 기존 타이머가 존재하면 종료 후 덮어쓰기
            await self.stop_timer()
        self.remain = self.duration
        self.finished = False
        self._paused = False
        self._stop = False
        self._timer_task = asyncio.create_task(self._timer())
    
    async def stop_timer(self):
        """실행중인 타이머 종료"""
        self._stop = True
        if self._timer_task is not None:
            await self._timer_task
            self._timer_task = None
        self.remain = self.duration
    
    async def pause_timer(self):
        """타이머 일시정지"""
        self._paused = True
    
    async def resume_timer(self):
        """타이머 재개"""
        self._paused = False
    
    async def set_duration(self, duration: float):
        """타이머 시간 설정

        Args:
            duration (float): 설정할 타이머 시간
        """
        self.duration = duration
        self.remain = self.duration
    
    async def get_state(self) -> TimerState:
        """현재 타이머 상태

        Returns:
            TimerState: 타이머 상태
        """
        if self.finished:
            return TimerState.READY
        elif self._paused:
            return TimerState.PAUSED
        elif self._stop:
            return TimerState.STOPPED
        else:
            return TimerState.RUNNING