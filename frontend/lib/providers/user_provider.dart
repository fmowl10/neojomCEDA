import 'package:flutter/material.dart';
import 'package:neojom_ceda/model/user.dart';
import 'package:neojom_ceda/model/state.dart' as StateModel;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  final endPoint = "ceda.quokkaandco.dev";
  final User _user;
  StateModel.State _currentState = StateModel.State("", "", "", 0, "", false);

  bool isVoted = false;

  UserProvider(this._user);

  int get roomId => _user.roomId;
  set roomId(int roomId) {
    _user.roomId = roomId;
    notifyListeners();
  }

  String get role => _user.role;
  void setRole(String role) {
    _user.role = role;
    notifyListeners();
  }

  String get uuid => _user.uuid;
  set uuid(String uuid) {
    _user.uuid = uuid;
  }

  StateModel.State get currentState => _currentState;

  Future<void> fetchState() async {
    var url = Uri.http(endPoint, "$roomId/state");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = StateModel.State.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
      _currentState = jsonResponse;
      notifyListeners();
    }
  }

  Future<void> poll() async {
    if (role != 'LISTNER') {
      return;
    }
    final param = {"positive": false};
    final url = Uri.https(endPoint, "$roomId/poll", param);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['result'] == 'ok') {
        isVoted = true;
        notifyListeners();
      }
    }
  }
}
