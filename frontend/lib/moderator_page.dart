import 'package:flutter/material.dart';
import 'package:neojom_ceda/component/state_component.dart';
import 'package:neojom_ceda/providers/moderator_provider.dart';
import 'package:neojom_ceda/model/user.dart';
import 'package:provider/provider.dart';

class ModeratorPage extends StatelessWidget {
  final int roomId;
  final String uuid;

  const ModeratorPage(this.roomId, this.uuid, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ModeratorProvider>(
        create: (context) {
          var provider = ModeratorProvider(User(roomId, "MODERATOR", uuid));
          return provider;
        },
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("사회자")),
          body: Center(
              child: Column(
            children: [
              Text('방번호 $roomId'),
              StateComponent(),
              ElevatedButton(
                  onPressed: () async {
                    await Provider.of<ModeratorProvider>(context, listen: false)
                        .fetchState();
                  },
                  child: Text("dddd"))
            ],
          )),
        ));
  }
}
