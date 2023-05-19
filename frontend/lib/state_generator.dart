import 'package:neojom_ceda/speaker.dart';

// constructive : 입론
// examination : 교차조사
// rebuttal : 반론
enum StateKind { constructive, examination, rebuttal, poll, breakTime, none }

class StateGenerator {
  int currentIndex = 0;

  State next() {
    if (currentIndex == stateList.length) {
      throw "END";
    }
    currentIndex++;
    State nextState = stateList[currentIndex];
    return nextState;
  }

  State prev() {
    if (currentIndex < 0 || currentIndex >= stateList.length) {
      throw "END";
    }
    currentIndex--;
    State prevState = stateList[currentIndex];
    return prevState;
  }

  State cur() {
    State curState = stateList[currentIndex];
    return curState;
  }

  State breakTime(Duration duration) {
    State breakState =
        State(stateKind: StateKind.breakTime, duration: duration);
    return breakState;
  }
}

class State {
  SpeakerRole arguer = SpeakerRole.none;
  SpeakerRole defender = SpeakerRole.none;
  StateKind stateKind = StateKind.none;

  Duration duration = const Duration();

  State(
      {SpeakerRole argure = SpeakerRole.none,
      SpeakerRole defender = SpeakerRole.none,
      StateKind stateKind = StateKind.none,
      Duration duration = const Duration()});
}

// CEDA 토론 규칙 기반하여 나열
final stateList = <State>[
  // 찬성자 1 입론
  State(
      argure: SpeakerRole.affrimate1st,
      stateKind: StateKind.constructive,
      duration: const Duration(minutes: 6)),
  // 반대자 2 교차
  State(
      argure: SpeakerRole.negative2nd,
      defender: SpeakerRole.affrimate1st,
      stateKind: StateKind.examination,
      duration: const Duration(minutes: 3)),
  // 반대자 1 입론
  State(
      argure: SpeakerRole.negative1st,
      stateKind: StateKind.constructive,
      duration: const Duration(minutes: 6)),
  // 찬성자 1 교차
  State(
      argure: SpeakerRole.affrimate1st,
      defender: SpeakerRole.negative1st,
      stateKind: StateKind.examination,
      duration: const Duration(minutes: 3)),
  // 찬성자 2 입론
  State(
      argure: SpeakerRole.affrimate2nd,
      stateKind: StateKind.constructive,
      duration: const Duration(minutes: 6)),
  // 반대자 1 교차
  State(
      argure: SpeakerRole.negative1st,
      defender: SpeakerRole.affrimate2nd,
      stateKind: StateKind.examination,
      duration: const Duration(minutes: 3)),
  // 반대자 2 입론
  State(
      argure: SpeakerRole.negative2nd,
      stateKind: StateKind.constructive,
      duration: const Duration(minutes: 6)),
  // 찬성자 2 교차
  State(
      argure: SpeakerRole.affrimate2nd,
      defender: SpeakerRole.negative2nd,
      stateKind: StateKind.examination,
      duration: const Duration(minutes: 3)),
  State(
      argure: SpeakerRole.negative1st,
      stateKind: StateKind.rebuttal,
      duration: const Duration(minutes: 4)),
  State(
      argure: SpeakerRole.affrimate1st,
      stateKind: StateKind.rebuttal,
      duration: const Duration(minutes: 4)),
  State(
      argure: SpeakerRole.negative2nd,
      stateKind: StateKind.rebuttal,
      duration: const Duration(minutes: 4)),
  State(
      argure: SpeakerRole.affrimate2nd,
      stateKind: StateKind.rebuttal,
      duration: const Duration(minutes: 4))
];
