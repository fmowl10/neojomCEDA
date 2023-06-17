import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:neojom_ceda/model/user.dart';
import 'package:neojom_ceda/model/poll_result.dart';

class Moderator extends User {
  Moderator(int roomId, String role, String uuid) : super(roomId, role, uuid);
  Future<bool> next() async {
    final param = {"uuid": uuid};
    final uri = Uri.https(endPoint, '$roomId/next', param);
    var res =
        await http.get(uri, headers: {"Content-Type": "application/json"});
    if (res.statusCode == 0) return true;
    return false;
  }

  Future<bool> prev() async {
    final param = {"uuid": uuid};
    final uri = Uri.https(endPoint, '$roomId/prev', param);
    var res =
        await http.get(uri, headers: {"Content-Type": "application/json"});
    if (res.statusCode == 0) return true;
    return false;
  }

  Future<bool> start() async {
    final param = {"uuid": uuid};
    final uri = Uri.https(endPoint, '$roomId/start', param);
    var res =
        await http.get(uri, headers: {"Content-Type": "application/json"});
    if (res.statusCode == 0) return true;
    return false;
  }

  Future<bool> pause() async {
    final param = {"uuid": uuid};
    final uri = Uri.https(endPoint, '$roomId/pause', param);
    var res =
        await http.get(uri, headers: {"Content-Type": "application/json"});
    if (res.statusCode == 0) return true;
    return false;
  }

  Future<bool> restart() async {
    final param = {"uuid": uuid};
    final uri = Uri.https(endPoint, '$roomId/restart', param);
    var res =
        await http.get(uri, headers: {"Content-Type": "application/json"});
    if (res.statusCode == 0) return true;
    return false;
  }

  Future<PollResult?> getPollResult() async {
    final param = {"uuid": uuid};
    final uri = Uri.https(endPoint, '$roomId/poll-result', param);

    var response = await http.get(uri, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      var pollResult = convert
          .jsonDecode(convert.utf8.decode(response.bodyBytes)) as PollResult;
      return pollResult;
    }
    return null;
  }

  Future<bool> breakTime(int second) async {
    final param = {"uuid": uuid, "duration": second.toString()};
    final uri = Uri.https(endPoint, '$roomId/break_time', param);
    var res =
        await http.get(uri, headers: {"Content-Type": "application/json"});
    if (res.statusCode == 0) return true;
    return false;
  }
}
