import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_goose/models/game_result_single_record.dart';
import 'package:golden_goose/utils/formatter.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'account.dart';
import 'game_type_model.dart';

part 'game_result_model.g.dart';

//flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
class GameResultModel {
  static DateFormat dateFormat = DateFormat("yyyy.MM.dd HH:mm");

  final GameTypeModel gameTypeModel;

  final Account initialAccount;
  final Account gameAccount;

  final List<GameResultSingleRecord> records;

  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime date;

  int get revenue => gameAccount.balance - initialAccount.balance;

  double get revenueRate => revenue / initialAccount.balance;

  String get formattedRevenue =>
      Formatter.formatBalance(balance: revenue, showSign: true);

  String get formattedRevenueRate =>
      Formatter.formatPercent(rate: revenueRate, showSign: true);

  String get formattedDate => dateFormat.format(date);

  GameResultModel({
    required this.gameTypeModel,
    required this.initialAccount,
    required this.gameAccount,
    required this.records,
    required this.date,
  });

  factory GameResultModel.fromDocumentSnapshot(
          {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) =>
      GameResultModel.fromJson(documentSnapshot.data()!);

  factory GameResultModel.fromJson(Map<String, dynamic> json) =>
      _$GameResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameResultModelToJson(this);

  static DateTime _dateTimeFromTimestamp(Timestamp timestamp) =>
      timestamp.toDate();

  static Timestamp _dateTimeToTimestamp(DateTime date) =>
      Timestamp.fromDate(date);
}
