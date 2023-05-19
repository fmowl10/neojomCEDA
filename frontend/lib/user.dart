import 'package:neojom_ceda/speaker.dart';
import 'package:neojom_ceda/state_generator.dart';

enum VoteSide { affrimate, negetive, none }

class User {
  final String roomNumber;

  User(this.roomNumber);
}

class Listner extends User {
  VoteSide voteSide = VoteSide.none;

  Listner(String roomNumber) : super(roomNumber);
}

class Moderator extends User {
  List<User> userList = <User>[];
  final StateGenerator _stateGenerator = StateGenerator();
  State? currentState;
  bool isEnd = false;

  Moderator(String roomNumber) : super(roomNumber);

  bool addListener(Listner listner) {
    userList.add(listner);
    return true;
  }

  bool addSpeaker(Speaker speaker) {
    for (var user in userList) {
      if (user is Speaker && user.speakerRole == speaker.speakerRole) {
        return false;
      }
    }
    return true;
  }

  void next() {
    try {
      currentState = _stateGenerator.next();
    } catch (e) {
      isEnd = true;
    }
  }
}
