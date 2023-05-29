import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neojom_ceda/moderator_page.dart';
import 'package:neojom_ceda/user_page.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'NeojomCEDA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String roomId = "";
  String topic = "";
  final roleItems = [
    "POSITIVE_SPEAKER1",
    "POSITIVE_SPEAKER2",
    "NEGATIVE_SPEAKER1",
    "NEGATIVE_SPEAKER2",
    "LISTENER"
  ];
  String role = "LISTENER";
  bool isFetching = false;
  String uuid = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: AbsorbPointer(
          absorbing: isFetching,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const Text("사회자"),
                          SizedBox(width: 200, child: TextField()),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UserPage(roomId)));
                              },
                              child: const Text("방만들기"))
                        ],
                      )),
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          const Text('일반유저'),
                          DropdownButton(
                              value: role,
                              items: roleItems
                                  .map((roleItem) => DropdownMenuItem(
                                      value: roleItem, child: Text(roleItem)))
                                  .toList(),
                              onChanged: (newRole) => setState(() {
                                    role = newRole!;
                                  })),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "input room id"),
                              onChanged: (inputed) => setState(() {
                                roomId = inputed;
                              }),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                if (roomId.isEmpty) {
                                  return;
                                }
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return ModeratorPage(roomId);
                                  },
                                ));
                              },
                              child: const Text("입장"))
                        ],
                      ))
                ],
              )
            ],
          ))),
    );
  }

  Future join() async {
    final param = {"role": role};
    final url = Uri.http("/", "$roomId", param);
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    var jsonResponse = await jsonDecode(response.body);

    uuid = jsonResponse['uuid'];
  }

  Future create() async {
    final param = {"topic": topic};
    final url = Uri.http("/", "create", param);
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    var jsonResponse = await jsonDecode(response.body);

    uuid = jsonResponse['uuid'];
    roomId = jsonResponse['room_id'];
  }
}
