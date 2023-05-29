// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

State _$StateFromJson(Map<String, dynamic> json) => State(
      json['arguer'] as String,
      json['defender'] as String,
      json['kind'] as String,
      json['time_Left'] as int,
      json['timer_state'] as String,
      json['is_finished'] as bool,
    );

Map<String, dynamic> _$StateToJson(State instance) => <String, dynamic>{
      'arguer': instance.arguer,
      'defender': instance.defender,
      'kind': instance.kind,
      'time_Left': instance.timeLeft,
      'timer_state': instance.timerState,
      'is_finished': instance.isFinished,
    };
