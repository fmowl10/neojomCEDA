import 'package:flutter/material.dart';
import 'package:neojom_ceda/component/state_model_component.dart';
import 'package:neojom_ceda/poll_result_page.dart';
import 'package:neojom_ceda/provider/neojom_ceda_provider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = context.watch<NeojomCEDAProvider>().user;
    final state = context.watch<NeojomCEDAProvider>().currentState;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('${user!.roomId} 방 역할 : ${user.role}')),
        body: Center(
          child: Column(children: [
            const StateModelComponent(),
            if (user.role == state.arguer) const Text("발언하시면 됩니다."),
            if (user.role == state.defender) const Text("현재, 방어자이십니다."),
            if (context.watch<NeojomCEDAProvider>().isPollEnd)
              ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PollResultPage())),
                  child: const Text("투표 결과 보기")),
            if (state.kind == '투표' &&
                !state.isFinished &&
                user.role == 'LISTENER' &&
                !user.isVoted)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await context.read<NeojomCEDAProvider>().doPoll(false);
                        user.isVoted = true;
                        user.votedSide = "반대";
                      },
                      child: const Text('반대에 투표')),
                  ElevatedButton(
                      onPressed: () async {
                        await context.read<NeojomCEDAProvider>().doPoll(true);
                        user.isVoted = true;
                        user.votedSide = "찬성";
                      },
                      child: const Text('찬성에 투표')),
                ],
              ),
            if (user.isVoted) Text("${user.votedSide}에 투표하셨습니다.")
          ]),
        ));
  }
}
