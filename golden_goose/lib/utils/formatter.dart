import 'package:intl/intl.dart';

class Formatter {
  static final percentFormat =
      NumberFormat.decimalPercentPattern(decimalDigits: 2);
  static final numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);

  static String formatPercent(
      {double? rate, bool showSign = false, String symbol = '\$'}) {
    if (rate == null) return "-";
    if (rate.isInfinite || rate.isNaN) return "-";
    String rateText = percentFormat.format(rate);
    rateText = rateText.replaceAll(RegExp(r'[-+]'), "");
    if (showSign) {
      if (rate > 0) {
        rateText = "+${rateText}";
      }
      if (rate < 0) {
        rateText = "-${rateText}";
      }
    }

    return rateText;
  }

  static String formatBalance(
      {int? balance, bool showSign = true, String symbol = '\$'}) {
    if (balance == null) return "-";
    String balanceText = numberFormat.format(balance);
    balanceText = balanceText.replaceAll(RegExp(r'[-+]'), "");
    if (showSign) {
      if (balance > 0) {
        balanceText = "+${balanceText}";
      }
      if (balance < 0) {
        balanceText = "-${balanceText}";
      }
    }
    return "${symbol} ${balanceText}";
  }
}
