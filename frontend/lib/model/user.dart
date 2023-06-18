class User {
  final String endPoint = "ceda.quokkaandco.dev";
  int roomId;
  String role;
  String uuid;
  bool isVoted = false;
  String votedSide = "";

  User(this.roomId, this.role, this.uuid);
}
