import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/currencies_controller.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  static const String path = "/Home";
  final uc = Get.find<UserController>();
  final cc = Get.find<CurrenciesController>();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Column(
                      children: [
                        const Center(
                          child: const Text("오 징 어 게 임",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                        const Center(
                          child: const Text("누 적 적 립 금",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const Center(
                          child: const Text("2,324,203 \$",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    /*
                    SizedBox(height: 10),
                    Grid(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: IntrinsicHeight(
                          child: Row(children: [
                            Column(
                              children: [
                                Text("+7,000,000"),
                                Text("62%"),
                              ],
                            ),
                            VerticalVarWithPadding(),
                            Column(
                              children: [
                                Text("+7,000,000"),
                                Text("62%"),
                              ],
                            ),
                            VerticalVarWithPadding(),
                            Column(
                              children: [
                                Text("+7,000,000"),
                                Text("62%"),
                              ],
                            ),
                            VerticalVarWithPadding(),
                            Column(
                              children: [
                                Text("+7,000,000"),
                                Text("62%"),
                              ],
                            ),
                            VerticalVarWithPadding(),
                            Column(
                              children: [
                                Text("+7,000,000"),
                                Text("62%"),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ),
                     */
                    SizedBox(height: 50),
                    SizedBox(
                      height: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Grid(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Rank",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30)),
                                    SizedBox(height: 10),
                                    Text("1st",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 25)),
                                  ],
                                )),
                              )),
                          Expanded(
                              flex: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 50,
                                      child: Grid(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(),
                                            Text("Balanace",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            SizedBox(height: 2),
                                            Obx(() {
                                              return buildBalanceText("${uc.user.rankMoney}");
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                        flex: 50,
                                        child: Grid(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(),
                                            Text("Recent",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            SizedBox(height: 2),
                                            Text("80.2%",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15)),
                                          ],
                                        ))),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.onBackground.withOpacity(0.44),
                  borderRadius: BorderRadius.all(Radius.circular(04.0)),
                ),
                child: Column(
                  children: List.generate(10, (index) => ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Map'),

                  )),
                ),
              ),

               */

              // Obx(() => CryptoListWidget(cc.list.value)),
            ],
          ),
        ),
      ),
    );
  }

  Text buildBalanceText(String text) {
    return Text(text,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal,
                                                  fontSize: 15));
  }
}

class VerticalVarWithPadding extends StatelessWidget {
  final double? width;

  const VerticalVarWithPadding({Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width ?? 8.0),
      child: Container(width: 1, color: Colors.white),
    );
  }
}

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({
    Key? key,
    this.child,
    this.padding,
    this.decoration,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),

    this.onTap,
  }) : super(key: key);
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final BorderRadius borderRadius;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: decoration == null
              ? Get.theme.colorScheme.onBackground.withOpacity(0.14)
              : decoration!.color,
          borderRadius: decoration != null && decoration!.borderRadius != null
              ? decoration!.borderRadius
              : borderRadius,
        ),
        child: Grid(child: child, decoration: BoxDecoration()),
      ),
    );
  }
}


class CryptoListWidget extends StatelessWidget {
  final Map currencyName = {
    "BTC": "Bitcoin",
    "ETH": "Ethereum",
    "XRP": "Ripple",
  };
  final List<MaterialColor> _colors = [Colors.blue, Colors.indigo, Colors.red];
  final Map _currencies;
  final List _currencyKeys;

  CryptoListWidget(this._currencies)
      : _currencyKeys = _currencies.keys.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      // A top margin of 56.0. A left and right margin of 8.0. And a bottom margin of 0.0.
      margin: const EdgeInsets.fromLTRB(0.0, .0, 0.0, 0.0),
      child: Column(
          // A column widget can have several widgets that are placed in a top down fashion
          children: [_getAppTitleWidget(), ...buildCurrenciesList()]),
    );
  }

  List<Widget> buildCurrenciesList() {
    return List.generate(_currencyKeys.length, (index) {
      if (_currencyKeys[index] == "date") {
        return Container();
      }
      return _getListItemWidget(
          currency: _currencies[_currencyKeys[index]],
          color: _colors[index % _colors.length],
          name: _currencyKeys[index]);
    });
  }

  Widget _getAppTitleWidget() {
    return const Text(
      'Cryptocurrencies',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
    );
  }

  Widget _getTextFromLeft(Map currency) {
    final price = double.parse(currency['closing_price']);
    final percentChange1h = double.parse(currency['fluctate_24H']);
    final fluctateRate = double.parse(currency['fluctate_rate_24H']);
    final accTraded = double.parse(currency['acc_trade_value_24H']);
    final unitsTraded = double.parse(currency['units_traded_24H']);
    var priceFormat = NumberFormat.currency(name: '', decimalDigits: 0);
    if (price < 1000 && price >= 10) {
      priceFormat = NumberFormat.currency(name: '', decimalDigits: 2);
    } else if (price < 10) {
      priceFormat = NumberFormat.currency(name: '', decimalDigits: 4);
    }
    final tradedFormat = NumberFormat.currency(name: '', decimalDigits: 0);
    final tradedUnitFormat = NumberFormat.compact();

    TextSpan priceTextWidget = TextSpan(
      text: "${priceFormat.format(price)} ",
      style: TextStyle(
        fontSize: 15,
      ),
    );
    String percentChangeText = "${priceFormat.format(percentChange1h)}";
    TextSpan percentChangeTextWidget;

    if (percentChange1h > 0) {
      // Currency price increased. Color percent change text green
      percentChangeTextWidget = TextSpan(
        text: "+${fluctateRate}% +${percentChangeText}",
        style: TextStyle(
          color: Colors.green,
          fontSize: 10,
        ),
      );
    } else {
      // Currency price decreased. Color percent change text red
      percentChangeTextWidget = TextSpan(
        text: "-${fluctateRate}% ${percentChangeText}",
        style: TextStyle(
          color: Colors.red,
          fontSize: 10,
        ),
      );
    }

    TextSpan tradedTextWidget = TextSpan(
      text: "${tradedFormat.format(accTraded)}  ",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 10,
      ),
    );

    TextSpan unitsTradedTextWidget = TextSpan(
      text: "${tradedUnitFormat.format(unitsTraded)}",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 10,
      ),
    );

    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: [
          priceTextWidget,
          percentChangeTextWidget,
          TextSpan(text: "\n"),
          tradedTextWidget,
          unitsTradedTextWidget
        ],
      ),
    );
  }

  Widget _getListItemWidget(
      {required Map currency,
      required MaterialColor color,
      required String name}) {
    // Returns a container widget that has a card child and a top margin of 5.0
    return Padding(
      padding: const EdgeInsets.only(top: 1.0),
      child: Grid(
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.onBackground.withOpacity(0.24),
          borderRadius: const BorderRadius.all(Radius.circular(0.0)),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Text(name[0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ),
          title: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${name}  ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: currencyName[name] ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          subtitle: _getTextFromLeft(currency),
          trailing: null,
          isThreeLine: false,
          dense: true,
        ),
      ),
    );
  }
}

extension MyCurrencyFormat on num {
  static final _currencyWithPrefixSignAndSymbol =
      NumberFormat("+ \u00A4 0.00;- \u00A4 0.00");

  String toCurrencyFormat() {
    return this == 0 ? "0" : _currencyWithPrefixSignAndSymbol.format(this);
  }
}
