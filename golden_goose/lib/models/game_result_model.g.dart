// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameResultModel _$GameResultModelFromJson(Map<String, dynamic> json) =>
    GameResultModel(
      balanceAtStart: json['balanceAtStart'] as int? ?? 0,
      balanceAtEnd: json['balanceAtEnd'] as int? ?? 0,
      longWhenRise: json['longWhenRise'] as int? ?? 0,
      holdWhenRise: json['holdWhenRise'] as int? ?? 0,
      shortWhenRise: json['shortWhenRise'] as int? ?? 0,
      longWhenFall: json['longWhenFall'] as int? ?? 0,
      holdWhenFall: json['holdWhenFall'] as int? ?? 0,
      shortWhenFall: json['shortWhenFall'] as int? ?? 0,
      records: (json['records'] as List<dynamic>?)
              ?.map((e) =>
                  GameResultSingleRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GameResultModelToJson(GameResultModel instance) =>
    <String, dynamic>{
      'balanceAtStart': instance.balanceAtStart,
      'balanceAtEnd': instance.balanceAtEnd,
      'longWhenRise': instance.longWhenRise,
      'holdWhenRise': instance.holdWhenRise,
      'shortWhenRise': instance.shortWhenRise,
      'longWhenFall': instance.longWhenFall,
      'holdWhenFall': instance.holdWhenFall,
      'shortWhenFall': instance.shortWhenFall,
      'records': instance.records,
    };
