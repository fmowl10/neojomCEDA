// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateModel _$StateModelFromJson(Map<String, dynamic> json) => StateModel(
      json['arguer'] as String,
      json['defender'] as String,
      json['kind'] as String,
      (json['time_left'] as num).toDouble(),
      json['timer_state'] as String,
      json['is_finished'] as bool,
    );

Map<String, dynamic> _$StateModelToJson(StateModel instance) =>
    <String, dynamic>{
      'arguer': instance.arguer,
      'defender': instance.defender,
      'kind': instance.kind,
      'time_left': instance.timeLeft,
      'timer_state': instance.timerState,
      'is_finished': instance.isFinished,
    };
