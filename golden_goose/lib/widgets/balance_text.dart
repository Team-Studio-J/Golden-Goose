import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:golden_goose/utils/formatter.dart';

class BalanceTextSpan extends TextSpan {
  final int? balance;
  final bool showSign;
  final bool showColor;
  final TextStyle textStyle;
  final Color upColor;
  final Color? normalColor;
  final Color downColor;
  final String symbol;
  final double fontSize;

  const BalanceTextSpan(
      {Key? key,
      required this.balance,
      bool? showSign,
      bool? showColor,
      TextStyle? textStyle,
      Color? upColor,
      this.normalColor,
      Color? downColor,
      String? symbol,
      double? fontSize})
      : showSign = showSign ?? true,
        showColor = showColor ?? true,
        textStyle = textStyle ?? const TextStyle(),
        upColor = upColor ?? Colors.green,
        downColor = downColor ?? Colors.red,
        symbol = symbol ?? '\$',
        fontSize = fontSize ?? 12;

  TextSpan get() {
    if (balance == null) return const TextSpan(text: "-");
    TextStyle style =
        textStyle.copyWith(color: normalColor, fontSize: fontSize);
    if (showColor) {
      if (balance! > 0) {
        style = style.copyWith(
          color: upColor,
        );
      } else if (balance! < 0) {
        style = style.copyWith(
          color: downColor,
        );
      }
    }

    return TextSpan(
        text: Formatter.formatBalance(
            balance: balance, showSign: showSign, symbol: symbol),
        style: style);
  }
}
