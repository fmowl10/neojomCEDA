import 'package:neojom_ceda/model/poll_result.dart';
import 'package:neojom_ceda/providers/user_provider.dart';
import 'package:neojom_ceda/model/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';

class ModeratorProvider extends UserProvider {
  ModeratorProvider(User user) : super(user);

  PollResult? pollResult;

  Future<bool> next() async {
    final param = {"uuid": uuid};
    final uri = Uri.https(endPoint, '$roomId/next', param);
    return true;
  }

  Future<bool> prev() async {
    final param = {"uuid": uuid};
    final uri = Uri.https(endPoint, '$roomId/prev', param);
    return true;
  }

  Future<bool> start() async {
    final param = {"uuid": uuid};
    final uri = Uri.https(endPoint, '$roomId/start', param);
    return true;
  }

  Future<bool> pause() async {
    final param = {"uuid": uuid};
    final uri = Uri.https(endPoint, '$roomId/pause', param);
    return true;
  }

  Future<void> getPollResult() async {
    if (currentState.kind != "POLL") return;
    final param = {"uuid": uuid};
    final uri = Uri.https(endPoint, '$roomId/poll-result', param);

    var response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Accept": "*/*"
    });
    pollResult =
        convert.jsonDecode(utf8.decode(response.bodyBytes)) as PollResult;
    notifyListeners();
  }
}
