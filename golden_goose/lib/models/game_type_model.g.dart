// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameTypeModel _$GameTypeModelFromJson(Map<String, dynamic> json) =>
    GameTypeModel(
      marketType: $enumDecode(_$MarketTypeEnumMap, json['marketType']),
      intervalType: $enumDecode(_$IntervalTypeEnumMap, json['intervalType']),
      startTime: json['startTime'] as int,
      endTime: json['endTime'] as int?,
      limit: json['limit'] as int,
      accountType: $enumDecode(_$AccountTypeEnumMap, json['accountType']),
    );

Map<String, dynamic> _$GameTypeModelToJson(GameTypeModel instance) =>
    <String, dynamic>{
      'marketType': _$MarketTypeEnumMap[instance.marketType],
      'intervalType': _$IntervalTypeEnumMap[instance.intervalType],
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'limit': instance.limit,
      'accountType': _$AccountTypeEnumMap[instance.accountType],
    };

const _$MarketTypeEnumMap = {
  MarketType.BTC: 'BTC',
  MarketType.ETH: 'ETH',
  MarketType.BNB: 'BNB',
  MarketType.ADA: 'ADA',
  MarketType.XRP: 'XRP',
  MarketType.DOT: 'DOT',
  MarketType.DOGE: 'DOGE',
  MarketType.EOS: 'EOS',
  MarketType.LTC: 'LTC',
  MarketType.BCH: 'BCH',
  MarketType.ETC: 'ETC',
  MarketType.LRC: 'LRC',
};

const _$IntervalTypeEnumMap = {
  IntervalType.e1h: 'e1h',
  IntervalType.e2h: 'e2h',
  IntervalType.e4h: 'e4h',
  IntervalType.e6h: 'e6h',
  IntervalType.e8h: 'e8h',
  IntervalType.e12h: 'e12h',
  IntervalType.e1d: 'e1d',
};

const _$AccountTypeEnumMap = {
  AccountType.rank: 'rank',
  AccountType.unrank: 'unrank',
};
