import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

@JsonSerializable()
class State {
  final String arguer;
  final String defender;
  final String kind;
  @JsonKey(name: "time_left")
  final int timeLeft;
  @JsonKey(name: "timer_state")
  final String timerState;
  @JsonKey(name: "is_finished")
  final bool isFinished;

  State(this.arguer, this.defender, this.kind, this.timeLeft, this.timerState,
      this.isFinished);

  factory State.fromJson(Map<String, dynamic> json) => _$StateFromJson(json);

  Map<String, dynamic> toJson() => _$StateToJson(this);
}
