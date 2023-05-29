import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

@JsonSerializable()
class State {
  final String? arguer;
  final String? defender;
  final String kind;
  final int timeLimit;

  State(this.kind, this.timeLimit, {this.arguer, this.defender});

  factory State.fromJson(Map<String, dynamic> json) => _$StateFromJson(json);

  Map<String, dynamic> toJson() => _$StateToJson(this);
}
