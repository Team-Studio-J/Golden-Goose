// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String? ?? "empty",
      nickname: json['nickname'] as String? ?? "empty",
      email: json['email'] as String? ?? "empty",
    )
      ..rank = json['rank'] as int?
      ..rankUpdateDate =
          UserModel._dateTimeFromTimestamp(json['rankUpdateDate'] as Timestamp?)
      ..unitTimeBeforeRank = json['unitTimeBeforeRank'] as int?;

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'nickname': instance.nickname,
      'email': instance.email,
      'rank': instance.rank,
      'rankUpdateDate': UserModel._dateTimeToTimestamp(instance.rankUpdateDate),
      'unitTimeBeforeRank': instance.unitTimeBeforeRank,
    };
