// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      registrationDate: UserModel._dateTimeFromTimestampNonNull(
          json['registrationDate'] as Timestamp),
      nation: json['nation'] as String?,
    )
      ..rank = json['rank'] as int?
      ..rankUpdateDate =
          UserModel._dateTimeFromTimestamp(json['rankUpdateDate'] as Timestamp?)
      ..unitTimeBeforeRank = json['unitTimeBeforeRank'] as int?;

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'nickname': instance.nickname,
      'email': instance.email,
      'nation': instance.nation,
      'rank': instance.rank,
      'registrationDate':
          UserModel._dateTimeToTimestampNonNull(instance.registrationDate),
      'rankUpdateDate': UserModel._dateTimeToTimestamp(instance.rankUpdateDate),
      'unitTimeBeforeRank': instance.unitTimeBeforeRank,
    };
