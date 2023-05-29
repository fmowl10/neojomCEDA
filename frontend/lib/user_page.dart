import 'package:flutter/material.dart';
import 'package:neojom_ceda/model/user.dart';
import 'package:neojom_ceda/component/state_component.dart';
import 'package:neojom_ceda/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  final int roomId;
  final String uuid;
  final String role;
  const UserPage(this.roomId, this.uuid, this.role, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (context) => UserProvider(User(roomId, role, uuid)),
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text('$roomId')),
          body: Center(
            child: StateComponent(),
          )),
    );
  }
}
