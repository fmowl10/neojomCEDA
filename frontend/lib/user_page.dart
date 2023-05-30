import 'package:flutter/material.dart';
import 'package:neojom_ceda/model/user.dart';
import 'package:neojom_ceda/component/state_model_component.dart';
import 'package:neojom_ceda/model/state_model.dart';
import 'package:neojom_ceda/poll_result_page.dart';
import 'dart:async';

class UserPage extends StatefulWidget {
  final User user;
  const UserPage(this.user, {super.key});
  @override
  UserPageState createState() => UserPageState(user);
}

class UserPageState extends State<UserPage> {
  StateModel currentState = StateModel("", "", "", 0, "", false);
  User user;

  UserPageState(this.user);

  late Timer _timer;

  @override
  void initState() {
    startPolling();
    super.initState();
  }

  void startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      pollingStateModel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('${user.roomId} 방 역할 : ${user.role}')),
        body: Center(
          child: Column(children: [
            StateModelComponent(currentState),
            if (currentState.kind == '투표' &&
                user.role == 'LISTENER' &&
                !user.isVoted)
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await widget.user.poll(false);
                        user.isVoted = true;
                        user.votedSide = "반대";
                      },
                      child: const Text('반대에 투표')),
                  ElevatedButton(
                      onPressed: () async {
                        await user.poll(true);
                        user.isVoted = true;
                        user.votedSide = "찬성";
                      },
                      child: const Text('찬성에 투표')),
                ],
              ),
            Text(user.votedSide)
          ]),
        ));
  }

  void pollingStateModel() {
    user.fetchState().then(
      (state) {
        if (state != null) {
          if (state.timerState == 'READY' &&
              state.timeLeft == 0 &&
              state.kind == '투표') {
            _timer.cancel();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return PollResultPage(user.roomId);
            }));
          } else {
            setState(() {
              currentState = state;
            });
          }
        }
      },
    );
  }
}
