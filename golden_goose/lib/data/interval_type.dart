// 'e1h' == '1h' ('e' is just magic character)

enum IntervalType {
  /* disabled interval type */
//  e1m,
//  e3m,
//  e5m,
//  e15m,
//  e30m,

  e1h,
  e2h,
  e4h,
  e6h,
  e8h,
  e12h,
  e1d,

  /* unused interval type */
//  e3d,
//  e1w,
//  e1M,
}

extension IntervalTypeExtension on IntervalType {
  String get name {
    return toString().split('.').last.substring(1);
  }

  int toMilliseconds() {
    String t = name.substring(name.length - 1);
    int timeInT = int.parse(name.substring(0, name.length - 1));
    int multiplier = 0;
    switch (t) {
      case 's':
        multiplier = 1;
        break;
      case 'm':
        multiplier = 60;
        break;
      case 'h':
        multiplier = 3600;
        break;
      case 'd':
        multiplier = 86400;
        break;
      case 'w':
        multiplier = 7 * 86400;
        break;
      case 'M':
        multiplier = 30 * 86400;
        break;
      default:
        throw Exception("Interval is not valid");
    }
    return timeInT * multiplier * 1000;
  }
}
