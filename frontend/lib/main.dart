import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:neojom_ceda/moderator_page.dart';
import 'package:neojom_ceda/user_page.dart';
import 'package:neojom_ceda/provider/neojom_ceda_provider.dart';
import 'package:neojom_ceda/model/user.dart';
import 'package:neojom_ceda/constants.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NeojomCEDAProvider()),
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
  final roleItems = userRoles.values.toList().sublist(0, 5);
  String role = "객원";
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
                                  context.read<NeojomCEDAProvider>().user =
                                      User(roomId, "MODERATOR", uuid);
                                  context
                                      .read<NeojomCEDAProvider>()
                                      .startPolling();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ModeratorPage()));
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
                                  var roleENG = userRoles.keys.firstWhere(
                                      (element) => userRoles[element] == role,
                                      orElse: () => 'LISTENER');
                                  context.read<NeojomCEDAProvider>().user =
                                      User(roomId, roleENG, uuid);
                                  context
                                      .read<NeojomCEDAProvider>()
                                      .startPolling();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return const UserPage();
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
    var roleENG = userRoles.keys.firstWhere(
        (element) => userRoles[element] == role,
        orElse: () => 'LISTENER');

    final param = {"role": roleENG};
    final url = Uri.https(endPoint!, '$roomId/join', param);
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      uuid = jsonResponse['uuid'];
    }
  }

  // Future를
  Future<void> create() async {
    final param = {"topic": topic};
    final url = Uri.https(endPoint!, "create", param);
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    uuid = jsonResponse['uuid'];
    roomId = jsonResponse['room_id'];
  }
}
