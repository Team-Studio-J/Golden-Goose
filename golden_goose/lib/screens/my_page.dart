import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/databases/database.dart';
import 'package:golden_goose/models/account.dart';
import 'package:golden_goose/models/rank_model.dart';
import 'package:golden_goose/models/user_model.dart';
import 'package:golden_goose/utils/rank_text_converter.dart';
import 'package:golden_goose/widgets/balance_text.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:intl/intl.dart';

class MyPage extends StatefulWidget {
  static const String path = "/MyPage";

  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final uc = Get.find<UserController>();
  var numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);
  bool rankLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(children: [
                    Text("${uc.user.nickname} "),
                    CircleAvatar(child: Text("KR")),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Grid(child: Text("Rank ${uc.user.formattedRank}")),
                    Grid(child: Text("Balance ${uc.ofAccount(AccountType.rank).formattedBalance}")),
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
