// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      balance: json['balance'] as int? ?? Account.initialBalance,
      gameCount: json['gameCount'] as int? ?? 0,
      longWhenRise: json['longWhenRise'] as int? ?? 0,
      holdWhenRise: json['holdWhenRise'] as int? ?? 0,
      shortWhenRise: json['shortWhenRise'] as int? ?? 0,
      longWhenFall: json['longWhenFall'] as int? ?? 0,
      holdWhenFall: json['holdWhenFall'] as int? ?? 0,
      shortWhenFall: json['shortWhenFall'] as int? ?? 0,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'balance': instance.balance,
      'gameCount': instance.gameCount,
      'longWhenRise': instance.longWhenRise,
      'holdWhenRise': instance.holdWhenRise,
      'shortWhenRise': instance.shortWhenRise,
      'longWhenFall': instance.longWhenFall,
      'holdWhenFall': instance.holdWhenFall,
      'shortWhenFall': instance.shortWhenFall,
    };
