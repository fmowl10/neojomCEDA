import 'package:neojom_ceda/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StateComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return Center(
          child: Column(children: [
            Text(value.currentState.kind),
            Text(
                '${value.currentState.timeLeft / 60}: ${value.currentState.timeLeft % 60}'),
            if (value.currentState.arguer == "NONE")
              Text(value.currentState.arguer),
            if (value.currentState.defender == "NONE")
              Text(value.currentState.defender),
            Text("현재 타이머 상태${value.currentState.timerState}")
          ]),
        );
      },
    );
  }
}
