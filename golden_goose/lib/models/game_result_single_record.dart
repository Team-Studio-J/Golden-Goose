import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_goose/data/game_button_type.dart';
import 'package:golden_goose/utils/formatter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_result_single_record.g.dart';

//flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
class GameResultSingleRecord {
  int balanceBefore;
  int balanceAfter;
  double closingPriceBefore;
  double closingPriceAfter;
  double volumeBefore;
  double volumeAfter;
  GameButtonType buttonType;

  String get formattedBalanceBefore =>
      Formatter.formatBalance(balance: balanceBefore, showSign: false);

  String get formattedBalanceAfter =>
      Formatter.formatBalance(balance: balanceAfter, showSign: false);

  int get balanceFluctuate => balanceAfter - balanceBefore;

  double get priceFluctuate => closingPriceAfter - closingPriceBefore;

  double get volumeFluctuate => volumeAfter - volumeBefore;

  double get balanceFluctuateRate =>
      balanceBefore == 0 ? 0 : (balanceAfter - balanceBefore) / balanceBefore;

  double get priceFluctuateRate => closingPriceBefore == 0
      ? 0
      : (closingPriceAfter - closingPriceBefore) / closingPriceBefore;

  double get volumeFluctuateRate =>
      volumeBefore == 0 ? 0 : (volumeAfter - volumeBefore) / volumeBefore;

  GameResultSingleRecord({
    required this.balanceBefore,
    required this.balanceAfter,
    required this.closingPriceBefore,
    required this.closingPriceAfter,
    required this.volumeBefore,
    required this.volumeAfter,
    required this.buttonType,
  });

  factory GameResultSingleRecord.fromDocumentSnapshot(
          {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) =>
      GameResultSingleRecord.fromJson(documentSnapshot.data()!);

  factory GameResultSingleRecord.fromJson(Map<String, dynamic> json) =>
      _$GameResultSingleRecordFromJson(json);

  Map<String, dynamic> toJson() => _$GameResultSingleRecordToJson(this);
}
