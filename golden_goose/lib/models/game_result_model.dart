import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:golden_goose/data/game_button_type.dart';
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
  static final DateFormat dateFormat = DateFormat("yyyy.MM.dd HH:mm".tr);

  final GameTypeModel gameTypeModel;

  final Account initialAccount;
  final Account gameAccount;

  final List<GameResultSingleRecord> records;

  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime date;

  int get revenue => gameAccount.balance - initialAccount.balance;

  double get revenueRate => revenue / initialAccount.balance;

  int get revenueOnLong => records
      .map((record) => record.buttonType == GameButtonType.long
          ? record.balanceFluctuate
          : 0)
      .fold(0, (value, element) => value + element);

  int get revenueOnShort => records
      .map((record) => record.buttonType == GameButtonType.short
          ? record.balanceFluctuate
          : 0)
      .fold(0, (value, element) => value + element);

  double get fluctuateOnHold => records
      .map((record) => record.buttonType == GameButtonType.hold
          ? record.priceFluctuate
          : 0.0)
      .fold(.0, (value, element) => value + element);

  double get absFluctuateOnHold => records
      .map((record) => record.buttonType == GameButtonType.hold
          ? record.priceFluctuate.abs()
          : 0.0)
      .fold(.0, (value, element) => value + element);

  double get absFluctuateRateSum => records
      .map((record) => record.priceFluctuateRate.abs())
      .fold(.0, (value, element) => value + element);

  double get absFluctuateRateSumOnLong => records
      .map((record) => record.buttonType == GameButtonType.long
      ? record.priceFluctuateRate.abs()
      : 0.0)
      .fold(.0, (value, element) => value + element);


  double get absFluctuateRateSumOnHold => records
      .map((record) => record.buttonType == GameButtonType.hold
          ? record.priceFluctuateRate.abs()
          : 0.0)
      .fold(.0, (value, element) => value + element);

  double get absFluctuateRateSumOnShort => records
      .map((record) => record.buttonType == GameButtonType.short
      ? record.priceFluctuateRate.abs()
      : 0.0)
      .fold(.0, (value, element) => value + element);


  String get formattedRevenue =>
      Formatter.formatBalance(balance: revenue, showSign: true, symbol: '');

  String get formattedRevenueRate =>
      Formatter.formatPercent(rate: revenueRate, showSign: true);

  String get formattedDate => dateFormat.format(date);

  String get formattedExpectedIncomeOnBetting => gameAccount.trialCount == 0
      ? "-"
      : Formatter.formatBalance(
          balance: ((gameAccount.balance - initialAccount.balance) /
                  gameAccount.trialCount)
              .round(),
          symbol: '');

  String get formattedExpectedIncomeOnLong => gameAccount.longs == 0
      ? "-"
      : Formatter.formatBalance(
          balance: (revenueOnLong / gameAccount.longs).round(), symbol: '');

  String get formattedExpectedIncomeOnShort => gameAccount.shorts == 0
      ? "-"
      : Formatter.formatBalance(
          balance: (revenueOnShort / gameAccount.shorts).round(), symbol: '');

  String get formattedFluctuateTotalOnHolds =>
      fluctuateOnHold.toStringAsFixed(2);

  String get formattedAverageAbsFluctuateRate => gameAccount.totalCount == 0
      ? "-"
      : Formatter.formatPercent(
          rate: absFluctuateRateSum / gameAccount.totalCount);

  String get formattedAverageAbsFluctuateRateOnHolds => gameAccount.holds == 0
      ? "-"
      : Formatter.formatPercent(
          rate: absFluctuateRateSumOnHold / gameAccount.holds);

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
