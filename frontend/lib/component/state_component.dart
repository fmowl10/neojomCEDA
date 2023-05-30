import 'package:neojom_ceda/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StateComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final current = context.watch<UserProvider>().currentState;

    return Consumer(
        builder: (context, value, child) => Center(
              child: Column(children: [
                Text(current.kind),
                Text('${current.timeLeft / 60}: ${current.timeLeft % 60}'),
                if (current.arguer == "NONE") Text(current.arguer),
                if (current.defender == "NONE") Text(current.defender),
                Text("현재 타이머 상태${current.timerState}")
              ]),
            ));
  }
}
