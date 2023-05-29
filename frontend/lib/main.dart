import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neojom_ceda/moderator_page.dart';
import 'package:neojom_ceda/user_page.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:neojom_ceda/model/user.dart';
import 'package:neojom_ceda/providers/moderator_provider.dart';
import 'package:neojom_ceda/providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(User(0, "", ""))),
        ChangeNotifierProvider(
            create: (_) => ModeratorProvider(User(0, "", "")))
      ],
      child: const MyApp(),
    ),
  );
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
  int roomId = 0;
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
                          SizedBox(
                              width: 200,
                              child: TextField(
                                  onChanged: (value) => setState(() {
                                        topic = value;
                                      }))),
                          TextButton(
                              onPressed: () {
                                create().then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ModeratorPage(roomId, uuid)));
                                });
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
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (inputed) => setState(() {
                                roomId = int.parse(inputed);
                              }),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                if (roomId == 0) {
                                  return;
                                }
                                join().then((value) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return UserPage(roomId, uuid, role);
                                    },
                                  ));
                                });
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

  Future<void> join() async {
    final param = {"role": role};
    final url = Uri.https("ceda.quokkaandco.dev", '$roomId/join', param);
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    var jsonResponse = jsonDecode(response.body);

    uuid = jsonResponse['uuid'];
  }

  // Future를
  Future<void> create() async {
    final param = {"topic": topic};
    final url = Uri.https("ceda.quokkaandco.dev", "create", param);
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Accept": "*/*"
    });
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    uuid = jsonResponse['uuid'];
    roomId = jsonResponse['room_id'];
  }
}
