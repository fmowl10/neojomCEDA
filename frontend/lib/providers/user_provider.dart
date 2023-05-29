import 'package:flutter/material.dart';
import 'package:neojom_ceda/model/user.dart';
import 'package:neojom_ceda/model/state.dart' as StateModel;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class UserProvider extends ChangeNotifier {
  final endPoint = "";
  final User _user;
  StateModel.State _currentState = StateModel.State("", 0);

  UserProvider(this._user);

  String get roomNumber => _user.roomId;
  set roomNumber(String roomNumber) {
    _user.roomId = roomNumber;
    notifyListeners();
  }

  String get role => _user.role;
  set role(String role) {
    _user.role = role;
    notifyListeners();
  }

  String get uuid => _user.uuid;
  set uuid(String uuid) {
    _user.uuid = uuid;
  }

  StateModel.State get currentState => _currentState;

  void fetchState() async {
    var url = Uri.http(endPoint, "${_user.roomId}/state");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as StateModel.State;
      _currentState = jsonResponse;
      notifyListeners();
    }
  }
}
