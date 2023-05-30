import 'package:neojom_ceda/model/state_model.dart';
import 'package:flutter/material.dart';

class StateModelComponent extends StatelessWidget {
  final StateModel currentState;
  const StateModelComponent(this.currentState);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('차례 : ${currentState.kind}'),
      if (currentState.timeLeft > 0)
        Text(
            '남은 시간 ${(currentState.timeLeft.floor() / 60).floor()} 분 ${currentState.timeLeft.floor() % 60} 초'),
      if (currentState.timeLeft <= 0) const Text('시간 만료'),
      if (currentState.arguer != "NONE") Text('발언자 ${currentState.arguer}'),
      if (currentState.defender != "NONE") Text('방어자 ${currentState.defender}'),
      Text("현재 타이머 상태 : ${currentState.timerState}")
    ]);
  }
}
