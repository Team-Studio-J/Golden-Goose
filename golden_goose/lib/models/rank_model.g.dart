// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RankModel _$RankModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['balance', 'rank', 'rankAccount', 'uid', 'user'],
  );
  return RankModel(
    balance: json['balance'] as int,
    rank: json['rank'] as int,
    uid: json['uid'] as String,
    rankAccount: Account.fromJson(json['rankAccount'] as Map<String, dynamic>),
    user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RankModelToJson(RankModel instance) => <String, dynamic>{
      'balance': instance.balance,
      'rank': instance.rank,
      'rankAccount': instance.rankAccount,
      'uid': instance.uid,
      'user': instance.user,
    };
