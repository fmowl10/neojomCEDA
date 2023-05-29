import 'package:flutter/material.dart';

class ModeratorPage extends StatefulWidget {
  final String roomId;
  final String uuid;
  const ModeratorPage(this.roomId, this.uuid);
  ModeratorPageState createState() => ModeratorPageState();
}

class ModeratorPageState extends State<ModeratorPage> {
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
