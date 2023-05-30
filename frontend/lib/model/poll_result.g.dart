// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollResult _$PollResultFromJson(Map<String, dynamic> json) => PollResult(
      json['positive'] as int,
      json['negative'] as int,
    );

Map<String, dynamic> _$PollResultToJson(PollResult instance) =>
    <String, dynamic>{
      'positive': instance.positive,
      'negative': instance.negative,
    };
