import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:neojom_ceda/model/state_model.dart';

class User {
  final String endPoint = "ceda.quokkaandco.dev";
  int roomId;
  String role;
  String uuid;
  bool isVoted = false;
  String votedSide = "";

  User(this.roomId, this.role, this.uuid);

  Future<StateModel?> fetchState() async {
    var param = {"uuid": uuid};
    var url = Uri.https(endPoint, "$roomId/state", param);
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      var jsonResponse =
          StateModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      return jsonResponse;
    }
    return null;
  }

  Future<void> poll(bool positive) async {
    if (role != 'LISTENER') {
      return;
    }

    final param = {"positive": positive ? 'true' : 'false', "uuid": uuid};
    final url = Uri.https(endPoint, "$roomId/poll", param);
    print(url);
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
  }
}
