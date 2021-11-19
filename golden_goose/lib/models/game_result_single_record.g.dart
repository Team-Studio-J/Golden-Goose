// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_result_single_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameResultSingleRecord _$GameResultSingleRecordFromJson(
        Map<String, dynamic> json) =>
    GameResultSingleRecord(
      balanceBefore: json['balanceBefore'] as int,
      balanceAfter: json['balanceAfter'] as int,
      closingPriceBefore: json['closingPriceBefore'] as int,
      closingPriceAfter: json['closingPriceAfter'] as int,
      volumeBefore: json['volumeBefore'] as int,
      volumeAfter: json['volumeAfter'] as int,
      buttonType: $enumDecode(_$GameButtonTypeEnumMap, json['buttonType']),
    );

Map<String, dynamic> _$GameResultSingleRecordToJson(
        GameResultSingleRecord instance) =>
    <String, dynamic>{
      'balanceBefore': instance.balanceBefore,
      'balanceAfter': instance.balanceAfter,
      'closingPriceBefore': instance.closingPriceBefore,
      'closingPriceAfter': instance.closingPriceAfter,
      'volumeBefore': instance.volumeBefore,
      'volumeAfter': instance.volumeAfter,
      'buttonType': _$GameButtonTypeEnumMap[instance.buttonType],
    };

const _$GameButtonTypeEnumMap = {
  GameButtonType.long: 'long',
  GameButtonType.hold: 'hold',
  GameButtonType.short: 'short',
};
