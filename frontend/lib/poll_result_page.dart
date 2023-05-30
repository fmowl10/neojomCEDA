import 'package:flutter/material.dart';
import 'package:neojom_ceda/model/poll_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';

class PollResultPage extends StatefulWidget {
  final int roomId;
  PollResultPage(this.roomId);

  State<PollResultPage> createState() => PollResultPageState();
}

class PollResultPageState extends State<PollResultPage> {
  PollResult pollResult = PollResult(0, 0);

  @override
  void initState() {
    fetchPollResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("사회자")),
        body: Center(
            child: Row(
          children: [
            Text("찬성 : ${pollResult.positive}"),
            Text("반대 : ${pollResult.negative}")
          ],
        )));
  }

  Future<void> fetchPollResult() async {
    final url =
        Uri.https("ceda.quokkaandco.dev", "${widget.roomId}/poll-result");
    var res =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (res.statusCode == 200) {
      var jsonResponse =
          PollResult.fromJson(json.decode(utf8.decode(res.bodyBytes)));
      setState(() {
        pollResult = jsonResponse;
      });
    }
  }
}
