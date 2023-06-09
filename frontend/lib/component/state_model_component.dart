import 'package:flutter/material.dart';
import 'package:neojom_ceda/constants.dart';
import 'package:neojom_ceda/provider/neojom_ceda_provider.dart';
import 'package:provider/provider.dart';

class StateModelComponent extends StatelessWidget {
  const StateModelComponent({super.key});
  @override
  Widget build(BuildContext context) {
    final currentState = context.watch<NeojomCEDAProvider>().currentState;

    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.deepPurple)),
        child: Column(children: [
          Text('차례 : ${currentState.kind}'),
          if (currentState.timeLeft > 0)
            Text(
                '남은 시간 ${(currentState.timeLeft.floor() / 60).floor()} 분 ${currentState.timeLeft.floor() % 60} 초'),
          if (currentState.timeLeft <= 0) const Text('시간 만료'),
          Text('발언자 ${userRoles[currentState.arguer]}'),
          Text('방어자 ${userRoles[currentState.defender]}'),
          Text("현재 타이머 상태 : ${currentState.timerState}")
        ]));
  }
}
