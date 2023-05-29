// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

State _$StateFromJson(Map<String, dynamic> json) => State(
      json['kind'] as String,
      json['timeLimit'] as int,
      arguer: json['arguer'] as String?,
      defender: json['defender'] as String?,
    );

Map<String, dynamic> _$StateToJson(State instance) => <String, dynamic>{
      'arguer': instance.arguer,
      'defender': instance.defender,
      'kind': instance.kind,
      'timeLimit': instance.timeLimit,
    };
