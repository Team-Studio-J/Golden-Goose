import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_goose/data/game_button_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_result_single_record.g.dart';

//flutter pub run build_runner build
@JsonSerializable()
class GameResultSingleRecord {
  int balanceBefore;
  int balanceAfter;
  int closingPriceBefore;
  int closingPriceAfter;
  int volumeBefore;
  int volumeAfter;
  GameButtonType buttonType;

  GameResultSingleRecord({
    required this.balanceBefore,
    required this.balanceAfter,
    required this.closingPriceBefore,
    required this.closingPriceAfter,
    required this.volumeBefore,
    required this.volumeAfter,
    required this.buttonType,
  });

  double get balanceFluctuate =>
      balanceBefore == 0 ? 0 : (balanceAfter - balanceBefore) / balanceBefore;

  double get priceFluctuate => closingPriceBefore == 0
      ? 0
      : (closingPriceAfter - closingPriceBefore) / closingPriceBefore;

  double get volumeFluctuate =>
      volumeBefore == 0 ? 0 : (volumeAfter - volumeBefore) / volumeBefore;

  factory GameResultSingleRecord.fromDocumentSnapshot(
          {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) =>
      GameResultSingleRecord.fromJson(documentSnapshot.data()!);

  factory GameResultSingleRecord.fromJson(Map<String, dynamic> json) =>
      _$GameResultSingleRecordFromJson(json);

  Map<String, dynamic> toJson() => _$GameResultSingleRecordToJson(this);
}
