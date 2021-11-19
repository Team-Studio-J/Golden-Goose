class Time {
  static int intervalToMilliseconds(String interval) {
    String t = interval.substring(interval.length - 1);
    int timeInT = int.parse(interval.substring(0, interval.length - 1));
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
      default:
        throw Exception("Interval is not valid");
    }
    return timeInT * multiplier * 1000;
  }
}
