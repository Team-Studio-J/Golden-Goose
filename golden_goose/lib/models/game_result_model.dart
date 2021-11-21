import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_goose/models/game_result_single_record.dart';
import 'package:json_annotation/json_annotation.dart';

import 'account.dart';
import 'game_type_model.dart';

part 'game_result_model.g.dart';

//flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
class GameResultModel {
  final GameTypeModel gameTypeModel;

  final int balanceAtStart;

  final Account gameAccount;

  final List<GameResultSingleRecord> records;

  GameResultModel({
    required this.gameTypeModel,
    required this.balanceAtStart,
    required this.gameAccount,
    required this.records,
  });

  factory GameResultModel.fromDocumentSnapshot(
          {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) =>
      GameResultModel.fromJson(documentSnapshot.data()!);

  factory GameResultModel.fromJson(Map<String, dynamic> json) =>
      _$GameResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameResultModelToJson(this);
}
