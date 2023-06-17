const String endPoint = "ceda.quokkaandco.dev";
const Map<String, String> userRoles = {
  "POSITIVE_SPEAKER1": "찬성 1",
  "POSITIVE_SPEAKER2": "찬성 2",
  "NEGATIVE_SPEAKER1": "반대 1",
  "NEGATIVE_SPEAKER2": "반대 2",
  "LISTENER": "객원"
};

const Map<String, String> defaultHeader = {"Content-Type": "application/json"};
const List<String> debateSelections = [
  "next",
  "prev",
  "start",
  "pause",
  "restart",
];
