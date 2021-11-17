import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceTextSpan extends TextSpan{
  static final numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);
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
    if (balance == null) return TextSpan(text :"-");
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

    String balanceText = numberFormat.format(balance!);
    balanceText = balanceText.replaceAll(RegExp(r'[-+]'),"");
    if (showSign) {
      if (balance! > 0) {
        balanceText = "+${balanceText}";
      }
      if (balance! < 0) {
        balanceText = "-${balanceText}";
      }
    }
    balanceText = "${symbol} ${balanceText}";
    return TextSpan(text: balanceText, style: style);
  }
}
