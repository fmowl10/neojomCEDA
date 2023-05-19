import 'package:neojom_ceda/user.dart';

enum SpeakerRole { affrimate1st, affrimate2nd, negative1st, negative2nd, none }

class Speaker extends User {
  final SpeakerRole speakerRole;
  final String name;
  Speaker(this.name, this.speakerRole, String roomName) : super(roomName);
}
