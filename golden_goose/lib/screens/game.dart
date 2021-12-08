import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/game_button_type.dart';
import 'package:golden_goose/data/market_type.dart';
import 'package:golden_goose/databases/database.dart';
import 'package:golden_goose/models/account.dart';
import 'package:golden_goose/models/game_result_model.dart';
import 'package:golden_goose/models/game_result_single_record.dart';
import 'package:golden_goose/models/game_type_model.dart';
import 'package:golden_goose/screens/result.dart';
import 'package:golden_goose/utils/candle_fetcher.dart';
import 'package:golden_goose/utils/interactive_chart/candle_data.dart';
import 'package:golden_goose/utils/interactive_chart/interactive_chart.dart';
import 'package:golden_goose/widgets/balance_text.dart';
import 'package:golden_goose/widgets/candlechart.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:intl/intl.dart';

class Game extends StatefulWidget {
  static const String path = "/Game";
  final GameTypeModel gameTypeModel;

  const Game({Key? key, required this.gameTypeModel}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final AuthController ac = Get.find<AuthController>();
  final UserController uc = Get.find<UserController>();
  static const initialOffset = 60;
  late Account initialAccount;
  late Account gameAccount;
  int balanceFluctuate = 0;
  double winRateFluctuate = 0;
  double winRate = 0;
  var percentFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);
  var numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);
  AnimationController? animateController1;
  AnimationController? animateController2;
  AnimationController? animateController3;
  AnimationController? animateController4;

  List<CandleData> candles = [];
  List<GameResultSingleRecord> records = [];
  bool isCandleUpdated = false;
  bool isGameResultUploading = false;

  @override
  void initState() {
    CandleFetcher.fetchCandles(
      gameTypeModel: widget.gameTypeModel,
    ).then((value) => setState(() {
          candles = value;
          // visibleLastOffset = candles.length - 1;
          assignCandleToData();
        }));
    initialAccount = uc.ofAccount(widget.gameTypeModel.accountType);
    gameAccount = Account(balance: initialAccount.balance);
    updateUser(randomly: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isGameResultUploading
            ? getUploadingWidget()
            : Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(widget.gameTypeModel.marketType.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                      child: _data.isEmpty
                          ? const Center(
                              child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator()))
                          : CandleChart(data: _data),
                      height: 400),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Salvatorie J",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              RichText(
                                  text: TextSpan(
                                      text:
                                          "${candles.length - 1 - visibleLastOffset} left")),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Grid(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                              text: const TextSpan(
                                                  text: "Balance")),
                                          Row(children: [
                                            balanceFluctuate > 0
                                                ? FadeInUp(
                                                    from: 5,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    controller: (controller) =>
                                                        animateController1 =
                                                            controller
                                                              ..forward(
                                                                  from: 0.0),
                                                    child: Text.rich(
                                                        BalanceTextSpan(
                                                      balance:
                                                          gameAccount.balance,
                                                      fontSize: 10,
                                                      showSign: false,
                                                      showColor: false,
                                                    ).get()),
                                                  )
                                                : FadeInDown(
                                                    from: 5,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    controller: (controller) =>
                                                        animateController1 =
                                                            controller
                                                              ..forward(
                                                                  from: 0.0),
                                                    child: Text.rich(
                                                        BalanceTextSpan(
                                                                balance:
                                                                    gameAccount
                                                                        .balance,
                                                                fontSize: 10,
                                                                showSign: false,
                                                                showColor:
                                                                    false)
                                                            .get()),
                                                  ),
                                            balanceFluctuate > 0
                                                ? FadeOutUp(
                                                    from: 20,
                                                    duration: const Duration(
                                                        milliseconds: 1000),
                                                    controller: (controller) =>
                                                        animateController2 =
                                                            controller
                                                              ..forward(
                                                                  from: 0.0),
                                                    child: Text.rich(
                                                        BalanceTextSpan(
                                                      balance: balanceFluctuate,
                                                      fontSize: 10,
                                                      showColor: true,
                                                      symbol: '',
                                                    ).get()),
                                                  )
                                                : FadeOutDown(
                                                    from: 20,
                                                    duration: const Duration(
                                                        milliseconds: 1000),
                                                    controller: (controller) =>
                                                        animateController2 =
                                                            controller
                                                              ..forward(
                                                                  from: 0.0),
                                                    child: Text.rich(
                                                        BalanceTextSpan(
                                                      balance: balanceFluctuate,
                                                      fontSize: 10,
                                                      showColor: true,
                                                      symbol: '',
                                                    ).get()),
                                                  ),
                                            /*
                                      FadeTransition(
                                        opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: curve)),
                                        child: Text(" ${percentFormat.format(
                                            winRateFluctuate)}", style: TextStyle(
                                            color: Colors.green, fontSize: 10)),
                                      )

                                       */
                                          ]),
                                        ]),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Grid(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                              text: const TextSpan(text: "Win Rate")),
                                          Row(children: [
                                            winRateFluctuate > 0
                                                ? FadeInUp(
                                                    from: 5,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    controller: (controller) =>
                                                        animateController3 =
                                                            controller
                                                              ..forward(
                                                                  from: 0.0),
                                                    child: Text(
                                                        percentFormat.format(winRate),
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 10)),
                                                  )
                                                : FadeInDown(
                                                    from: 5,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    controller: (controller) =>
                                                        animateController3 =
                                                            controller
                                                              ..forward(
                                                                  from: 0.0),
                                                    child: Text(
                                                        percentFormat.format(winRate),
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 10)),
                                                  ),
                                            winRateFluctuate > 0
                                                ? FadeOutUp(
                                                    from: 20,
                                                    duration: const Duration(
                                                        milliseconds: 1000),
                                                    controller: (controller) =>
                                                        animateController4 =
                                                            controller
                                                              ..forward(
                                                                  from: 0.0),
                                                    child: Text(
                                                        " +${percentFormat.format(winRateFluctuate)}",
                                                        style: const TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 10)),
                                                  )
                                                : FadeOutDown(
                                                    from: 20,
                                                    duration: const Duration(
                                                        milliseconds: 1000),
                                                    controller: (controller) =>
                                                        animateController4 =
                                                            controller
                                                              ..forward(
                                                                  from: 0.0),
                                                    child: Text(
                                                        " ${percentFormat.format(winRateFluctuate)}",
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 10)),
                                                  ),
                                            /*
                                      FadeTransition(
                                        opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: curve)),
                                        child: Text(" ${percentFormat.format(
                                            winRateFluctuate)}", style: TextStyle(
                                            color: Colors.green, fontSize: 10)),
                                      )

                                       */
                                          ]),
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                              child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: records.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (records.isEmpty) return getEmptyTile();
                              if (index == records.length) return Container();
                              var tileIndex = records.length - 1 - index;
                              return getRecordTile(
                                  records[tileIndex], tileIndex);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 2);
                            },
                          )),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  Expanded(
                                      flex: 2,
                                      child: ButtonGrid(
                                          onTap: () {
                                            run(GameButtonType.long);
                                          },
                                          decoration:
                                              const BoxDecoration(color: Colors.blue),
                                          child: const Center(child: Text("Long")))),
                                  const Spacer(),
                                  Expanded(
                                      flex: 2,
                                      child: ButtonGrid(
                                          onTap: () {
                                            run(GameButtonType.hold);
                                          },
                                          decoration:
                                              const BoxDecoration(color: Colors.grey),
                                          child: const Center(child: Text("Hold")))),
                                  const Spacer(),
                                  Expanded(
                                      flex: 2,
                                      child: ButtonGrid(
                                          onTap: () {
                                            run(GameButtonType.short);
                                          },
                                          decoration:
                                              const BoxDecoration(color: Colors.red),
                                          child: const Center(child: Text("Short")))),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget getFadeInWidget() {
    Widget text = Text(percentFormat.format(winRate),
        style: const TextStyle(color: Colors.grey, fontSize: 10));
    if (winRateFluctuate == 0) {
      return text;
    }
    return winRateFluctuate > 0
        ? FadeInUp(
            from: 5,
            duration: const Duration(milliseconds: 300),
            controller: (controller) =>
                animateController3 = controller..forward(from: 0.0),
            child: text,
          )
        : FadeInDown(
            from: 5,
            duration: const Duration(milliseconds: 300),
            controller: (controller) =>
                animateController3 = controller..forward(from: 0.0),
            child: text,
          );
  }

  int visibleLastOffset = initialOffset - 1;
  List<CandleData> _data = [];

  void run(GameButtonType type) {
    if (!isCandleUpdated) return;
    if (!canGoFront()) {
      endGame();
      // return will not be reached
      return;
    }
    goFrontOneCandle();
    double before = _data[visibleLastOffset - 1].close!;
    double after = _data[visibleLastOffset].close!;
    double rate = (after - before) / before;
    countButtons(type, rate);
    evaluateBalance(type, rate);
    if (type != GameButtonType.hold) {
      evaluateWinRate(type, rate);
      if (animateController1 != null) animateController1!.forward(from: 0.0);
      if (animateController2 != null) animateController2!.forward(from: 0.0);
      if (animateController3 != null) animateController3!.forward(from: 0.0);
      if (animateController4 != null) animateController4!.forward(from: 0.0);
    }
    records.add(GameResultSingleRecord(
      balanceBefore: gameAccount.balance - balanceFluctuate,
      balanceAfter: gameAccount.balance,
      volumeBefore: _data[visibleLastOffset].volume!,
      volumeAfter: _data[visibleLastOffset - 1].volume!,
      closingPriceAfter: _data[visibleLastOffset].close!,
      closingPriceBefore: _data[visibleLastOffset - 1].close!,
      buttonType: type,
    ));
    updateUser(randomly: true);
    setState(() {});
  }

  void endGame() {
    updateUser(randomly: false);
    final gameResult = GameResultModel(
      records: records,
      initialAccount: initialAccount,
      gameAccount: gameAccount,
      gameTypeModel: widget.gameTypeModel,
      date: DateTime.now(),
    );
    isGameResultUploading = true;
    Database.updateGameResult(gameResult, ac.user!).then((e) {
      Get.off(() => Result(
            gameResultModel: gameResult,
            candles: candles,
          ));
    });
  }

  bool canGoFront() {
    return visibleLastOffset < candles.length - 1;
  }

  void goFrontOneCandle() {
    // chart 에서 true 일시 한칸 앞으로 간다
    if (canGoFront()) {
      visibleLastOffset++;
      assignCandleToData();
      goFront = true;
    }
  }

  void assignCandleToData() {
    isCandleUpdated = true;
    _data = candles.sublist(0, visibleLastOffset + 1);
  }

  void evaluateWinRate(GameButtonType type, double rate) {
    if (type == GameButtonType.hold) {
      return;
    }

    var beforeWinRate = winRate;
    winRate = gameAccount.winRate;
    winRateFluctuate = winRate - beforeWinRate;
  }

  void evaluateBalance(GameButtonType type, double rate) {
    int beforeBalance = gameAccount.balance;

    switch (type) {
      case GameButtonType.long:
        gameAccount.balance += (rate * gameAccount.balance).round();
        break;
      case GameButtonType.hold:
        break;
      case GameButtonType.short:
        gameAccount.balance += -(rate * gameAccount.balance).round();
        break;
    }

    balanceFluctuate = gameAccount.balance - beforeBalance;
  }

  void countButtons(GameButtonType type, double rate) {
    if (rate >= 0) {
      switch (type) {
        case GameButtonType.long:
          gameAccount.longWhenRise++;
          break;
        case GameButtonType.hold:
          gameAccount.holdWhenRise++;
          break;
        case GameButtonType.short:
          gameAccount.shortWhenRise++;
          break;
      }
    } else {
      switch (type) {
        case GameButtonType.long:
          gameAccount.longWhenFall++;
          break;
        case GameButtonType.hold:
          gameAccount.holdWhenFall++;
          break;
        case GameButtonType.short:
          gameAccount.shortWhenFall++;
          break;
      }
    }
  }

  @override
  void dispose() {
    updateUser(randomly: false);
    super.dispose();
  }

  void updateUser({bool randomly = false}) {
    if (randomly) {
      if (Random().nextInt(100) >= 10) return; //10% 확률로 업데이트
    }
    Database.updateAccount(
        ac.user!,
        Account.nullSafeMapper(
          balance: gameAccount.balance,
          gameCount: initialAccount.gameCount + 1,
          longWhenRise: initialAccount.longWhenRise + gameAccount.longWhenRise,
          holdWhenRise: initialAccount.holdWhenRise + gameAccount.holdWhenRise,
          shortWhenRise:
              initialAccount.shortWhenRise + gameAccount.shortWhenRise,
          longWhenFall: initialAccount.longWhenFall + gameAccount.longWhenFall,
          holdWhenFall: initialAccount.holdWhenFall + gameAccount.holdWhenFall,
          shortWhenFall:
              initialAccount.shortWhenFall + gameAccount.shortWhenFall,
        ),
        widget.gameTypeModel.accountType);
  }

  Widget getUploadingWidget() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      Center(
          child: SizedBox(
              width: 20, height: 20, child: CircularProgressIndicator())),
      SizedBox(height: 20),
      Text("Uploading . . ."),
    ]);
  }

  Widget getEmptyTile() {
    return Grid(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        ),
        color: Colors.blueAccent.withOpacity(0.8),
        child: const Center(
            child: Text("포지션을 선택하여 진행하세요", style: TextStyle(fontSize: 10))));
  }

  Widget getRecordTile(GameResultSingleRecord record, int tileIndex) {
    return Grid(
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 1,
                child: Text("${tileIndex + 1}",
                    style:
                        const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
            Expanded(
              flex: 10,
              child: SizedBox(
                height: 20,
                child: RichText(
                  text: TextSpan(children: [
                    BalanceTextSpan(
                      balance: record.balanceAfter,
                      fontSize: 12,
                      showColor: false,
                      showSign: false,
                    ).get(),
                    record.balanceFluctuate != 0
                        ? BalanceTextSpan(
                            balance: record.balanceFluctuate,
                            fontSize: 10,
                            showColor: true,
                            symbol: '',
                          ).get()
                        : const TextSpan(),
                  ]),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 20,
              width: 40,
              child: Grid(
                padding: const EdgeInsets.all(0),
                color: record.buttonType.color,
                child: Center(
                  child: Text(record.buttonType.name,
                      style: const TextStyle(fontSize: 10)),
                ),
              ),
            ),
          ],
        ));
  }
}
