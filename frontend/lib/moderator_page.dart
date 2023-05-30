import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neojom_ceda/component/state_model_component.dart';
import 'package:neojom_ceda/model/moderator.dart';
import 'package:neojom_ceda/model/state_model.dart';
import 'dart:async';

import 'package:neojom_ceda/poll_result_page.dart';

class ModeratorPage extends StatefulWidget {
  final Moderator moderator;

  const ModeratorPage(this.moderator, {super.key});

  @override
  ModeratorPageState createState() => ModeratorPageState();
}

class ModeratorPageState extends State<ModeratorPage> {
  StateModel currentState = StateModel("", "", "", 0, "", false);
  late Timer _timer;
  int break_time = 0;

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
            title: const Text("사회자")),
        body: Center(
            child: Column(
          children: [
            const SizedBox(width: 200),
            Text('방번호 ${widget.moderator.roomId}'),
            StateModelComponent(currentState),
            const SizedBox(height: 20),
            const Text('차례 리모콘'),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: () async => await widget.moderator.prev(),
                  child: const Text('이전')),
              ElevatedButton(
                  onPressed: () async {
                    if (currentState.timerState == 'READY' ||
                        currentState.timerState == 'PAUSED') {
                      await widget.moderator.start();
                    }
                  },
                  child: const Text("시작")),
              ElevatedButton(
                  onPressed: () async => await widget.moderator.next(),
                  child: const Text('다음')),
            ]),
            const Text('타이머 리모콘'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async => await widget.moderator.pause(),
                    child: const Text('일시 정지')),
                ElevatedButton(
                    onPressed: () async => await widget.moderator.restart(),
                    child: const Text("리셋"))
              ],
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "input break time minute"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => setState(() {
                break_time = int.parse(value) * 60;
              }),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (currentState.kind == 'READY' && break_time != 0) {
                    await widget.moderator.breakTime(break_time);
                  }
                },
                child: Text("휴식 시간 전송(다음 버튼을 누르고 시작버튼을 누르세요)"))
          ],
        )));
  }

  void pollingStateModel() {
    widget.moderator.fetchState().then(
      (state) {
        if (state != null) {
          if (state.timerState == 'READY' &&
              state.timeLeft <= 0 &&
              state.kind == '투표') {
            _timer.cancel();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return PollResultPage(widget.moderator.roomId);
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
