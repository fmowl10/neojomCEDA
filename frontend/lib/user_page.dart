import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final String roomId;
  const UserPage(this.roomId);
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.roomId)),
      body: Center(child: Text("HEY")),
    );
  }
}
