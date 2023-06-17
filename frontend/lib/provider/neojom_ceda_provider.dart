import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neojom_ceda/model/user.dart';
import 'package:neojom_ceda/model/poll_result.dart';
import 'package:neojom_ceda/model/state_model.dart';
import 'package:neojom_ceda/constants.dart';

class NeojomCEDAProvider extends ChangeNotifier {
  User? user;
  StateModel _currentState = StateModel("", "", "", 0, "", false);
  PollResult _pollResult = PollResult(0, 0);
  late Timer _timer;

  StateModel get currentState => _currentState;
  PollResult get pollResult => _pollResult;

  void startPolling() {
    _timer = Timer.periodic(
        const Duration(seconds: 1), (timer) async => fetchStateModel());
  }

  void stopPolling() {
    _timer.cancel();
  }

  bool isModerator() {
    return user!.role == "MODERATOR" ? true : false;
  }

  bool isListener() {
    return user!.role == "LISTENER" ? true : false;
  }

  Future<void> fetchStateModel() async {
    if (user == null) throw Exception("blank user");
    var param = {"uuid": user!.uuid};
    var uri = Uri.https(endPoint, "${user!.roomId}/state", param);
    var response = await http.get(uri, headers: defaultHeader);
    if (response.statusCode != 200) throw Exception("fetch error");

    var jsonResponse =
        StateModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));

    _currentState = jsonResponse;
    notifyListeners();
  }

  Future<void> doPoll(bool isPositive) async {
    if (!isListener()) throw Exception("only listener can poll");

    final param = {
      "positive": isPositive ? "true" : 'false',
      "uuid": user!.uuid
    };

    final uri = Uri.https(endPoint, "${user!.roomId}/poll", param);
    var res = await http.get(uri, headers: defaultHeader);

    if (res.statusCode != 200) {
      throw Exception("fetchPollResult error ${res.statusCode}");
    }

    user!.isVoted = true;
  }

  Future<void> debateController(String selection) async {
    if (!isModerator()) throw Exception("only moderator take controll");
    if (debateSelections
        .firstWhere((element) => element == selection, orElse: () => '')
        .isEmpty) throw Exception("wrong selection of debate");
    final param = {"uuid": user!.uuid};
    final uri = Uri.https(endPoint, '${user!.roomId}/$selection', param);

    var res = await http.get(uri, headers: defaultHeader);

    if (res.statusCode != 200) {
      throw Exception("debateController error: $selection");
    }
  }

  Future<void> giveBreakTime(double breakTime) async {
    if (!isModerator()) throw Exception("only moderator give break time");

    final param = {"uuid": user!.uuid, "duration": breakTime.toString()};
    final uri = Uri.https(endPoint, "${user!.roomId}/break_time", param);
    var res = await http.get(uri, headers: defaultHeader);

    if (res.statusCode != 200) {
      throw Exception("giveBreakTime error");
    }
  }

  Future<void> fetchPollResult() async {
    final param = {"uuid": user!.uuid};
    final uri = Uri.https(endPoint, "${user!.roomId}/poll-result", param);
    var res = await http.get(uri, headers: defaultHeader);
    if (res.statusCode != 200) {
      throw Exception("fetchPollResult error");
    }
    var fetchedPollResult =
        PollResult.fromJson(json.decode(utf8.decode(res.bodyBytes)));

    _pollResult = fetchedPollResult;
    notifyListeners();
  }
}
