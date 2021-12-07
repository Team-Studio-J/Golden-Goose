// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameResultModel _$GameResultModelFromJson(Map<String, dynamic> json) =>
    GameResultModel(
      gameTypeModel:
          GameTypeModel.fromJson(json['gameTypeModel'] as Map<String, dynamic>),
      balanceAtStart: json['balanceAtStart'] as int,
      gameAccount:
          Account.fromJson(json['gameAccount'] as Map<String, dynamic>),
      records: (json['records'] as List<dynamic>)
          .map(
              (e) => GameResultSingleRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: GameResultModel._dateTimeFromTimestamp(json['date'] as Timestamp),
    );

Map<String, dynamic> _$GameResultModelToJson(GameResultModel instance) =>
    <String, dynamic>{
      'gameTypeModel': instance.gameTypeModel.toJson(),
      'balanceAtStart': instance.balanceAtStart,
      'gameAccount': instance.gameAccount.toJson(),
      'records': instance.records.map((e) => e.toJson()).toList(),
      'date': GameResultModel._dateTimeToTimestamp(instance.date),
    };
