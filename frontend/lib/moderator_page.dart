import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neojom_ceda/poll_result_page.dart';
import 'package:neojom_ceda/component/state_model_component.dart';
import 'package:neojom_ceda/provider/neojom_ceda_provider.dart';
import 'package:provider/provider.dart';

class ModeratorPage extends StatefulWidget {
  const ModeratorPage({super.key});

  @override
  State<ModeratorPage> createState() => _ModeratorPageState();
}

class _ModeratorPageState extends State<ModeratorPage> {
  var textfield = TextEditingController();
  final breakTimeSnackbar =
      const SnackBar(content: Text("다음 버튼을 눌러 휴식을 시작하세요."));
  final nomoreNextSnackBar = const SnackBar(content: Text("더이상 남은 차례가 없습니다."));
  int breakTime = 0;
  @override
  Widget build(BuildContext context) {
    final moderator = context.watch<NeojomCEDAProvider>().user;
    final currentState = context.watch<NeojomCEDAProvider>().currentState;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("사회자")),
        body: Center(
            child: Column(
          children: [
            const SizedBox(width: 200),
            Text('방번호 ${moderator!.roomId}'),
            const StateModelComponent(),
            if (context.watch<NeojomCEDAProvider>().isPollEnd)
              ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PollResultPage())),
                  child: const Text("투표 결과 보기")),
            const SizedBox(height: 20),
            const Text('차례 리모콘'),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: () async => await context
                      .read<NeojomCEDAProvider>()
                      .debateController("prev"),
                  child: const Text('이전')),
              ElevatedButton(
                  onPressed: () async {
                    if (currentState.timerState == 'READY' ||
                        currentState.timerState == 'PAUSED') {
                      await context
                          .read<NeojomCEDAProvider>()
                          .debateController("start");
                    }
                  },
                  child: const Text("시작")),
              ElevatedButton(
                  onPressed: () async {
                    if (currentState.kind != "투표") {
                      await context
                          .read<NeojomCEDAProvider>()
                          .debateController("next");
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(nomoreNextSnackBar);
                    }
                  },
                  child: const Text('다음')),
            ]),
            const Text('타이머 리모콘'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async => await context
                        .read<NeojomCEDAProvider>()
                        .debateController("pause"),
                    child: const Text('일시 정지')),
                ElevatedButton(
                    onPressed: () async => await context
                        .read<NeojomCEDAProvider>()
                        .debateController("reset"),
                    child: const Text("리셋"))
              ],
            ),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "input break time minute"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => setState(() {
                breakTime = int.parse(value);
              }),
              controller: textfield,
            ),
            ElevatedButton(
                onPressed: () {
                  if (currentState.timerState == 'READY' && breakTime != 0) {
                    // 분을 초로 변환
                    context
                        .read<NeojomCEDAProvider>()
                        .giveBreakTime(breakTime * 60);
                    breakTime = 0;
                    //textfield.clear();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(breakTimeSnackbar);
                  } else {}
                },
                child: const Text("휴식 시간 전송(다음 버튼을 누르고 시작버튼을 누르세요)"))
          ],
        )));
  }
}
