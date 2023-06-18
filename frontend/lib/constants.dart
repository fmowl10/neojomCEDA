import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var endPoint = dotenv.env['APISERVER'];
const Map<String, String> userRoles = {
  "POSITIVE_SPEAKER1": "찬성 1",
  "POSITIVE_SPEAKER2": "찬성 2",
  "NEGATIVE_SPEAKER1": "반대 1",
  "NEGATIVE_SPEAKER2": "반대 2",
  "LISTENER": "객원",
  "NONE": "없음"
};

const Map<String, String> defaultHeader = {"Content-Type": "application/json"};
const List<String> debateSelections = [
  "next",
  "prev",
  "start",
  "pause",
  "restart",
];

const kickedSankBar = SnackBar(content: Text("못들어가는 상태입니다. "));
