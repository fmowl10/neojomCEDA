import 'package:json_annotation/json_annotation.dart';

part 'poll_result.g.dart';

@JsonSerializable()
class PollResult {
  int positive;
  int negative;

  PollResult(this.positive, this.negative);

  factory PollResult.fromJson(Map<String, dynamic> json) =>
      _$PollResultFromJson(json);

  Map<String, dynamic> toJson() => _$PollResultToJson(this);
}
