import 'package:json_annotation/json_annotation.dart';

part 'state_model.g.dart';

@JsonSerializable()
class StateModel {
  final String arguer;
  final String defender;
  final String kind;
  @JsonKey(name: "time_left")
  final double timeLeft;
  @JsonKey(name: "timer_state")
  final String timerState;
  @JsonKey(name: "is_finished")
  final bool isFinished;

  StateModel(this.arguer, this.defender, this.kind, this.timeLeft,
      this.timerState, this.isFinished);

  factory StateModel.fromJson(Map<String, dynamic> json) =>
      _$StateModelFromJson(json);

  Map<String, dynamic> toJson() => _$StateModelToJson(this);
}
