import 'package:flutter/material.dart';
import 'package:neojom_ceda/component/poll_result_component.dart';

class PollResultPage extends StatelessWidget {
  const PollResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("투표결과")),
        body: const Center(
          child: PollResultComponent(),
        ));
  }
}
