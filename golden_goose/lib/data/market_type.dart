// ignore_for_file: constant_identifier_names

enum MarketType {
  BTC,
  ETH,
  BNB,
  ADA,
  XRP,
  DOT,
  DOGE,
  EOS,
  LTC,
  BCH,
  ETC,
  LRC,
}

extension MarketTypeExtension on MarketType {
  String get assetPath {
    switch (this) {
      case MarketType.BNB:
        return 'assets/cryptocurrency/$coinSymbolName.png';
      default:
        break;
    }
    return 'assets/cryptocurrency/$coinSymbolName.png';
  }

  bool get needBackground {
    switch (this) {
      case MarketType.XRP:
        return true;
      case MarketType.DOT:
        return true;
      case MarketType.EOS:
        return true;
      default:
        return false;
    }
  }

  //String get name => describeEnum(this);
  String get name {
    return toString().split('.').last + "USDT";
  }

  String get coinSymbolName {
    return toString().split('.').last;
  }

  String get symbolInBinanace {
    return toString().split('.').last + "USDT";
  }

  String get fullName {
    switch (this) {
      case MarketType.BTC:
        return "Bitcoin";
      case MarketType.ETH:
        return "Ethereum";
      case MarketType.BNB:
        return "Binance";
      case MarketType.ADA:
        return "Cardano";
      case MarketType.XRP:
        return "Ripple";
      case MarketType.DOT:
        return "Polkadot";
      case MarketType.DOGE:
        return "Doge";
      case MarketType.LTC:
        return "Litecoin";
      case MarketType.BCH:
        return "Bitcoin Cash";
      case MarketType.ETC:
        return "Ethereum Classic";
      case MarketType.LRC:
        return "Loopring";
      case MarketType.EOS:
        return "EOS";
    }
  }

  int get firstTime {
    switch (this) {
      case MarketType.BTC:
        return 1502942400000;
      case MarketType.ETH:
        return 1502942400000;
      case MarketType.EOS:
        return 1527483600000;
      case MarketType.XRP:
        return 1525421460000;
      case MarketType.DOT:
        return 1597791600000;
      case MarketType.BNB:
        return 1509940440000;
      case MarketType.ADA:
        return 1523937720000;
      case MarketType.DOGE:
        return 1562328000000;
      case MarketType.LTC:
        return 1513135920000;
      case MarketType.BCH:
        return 1574935200000;
      case MarketType.ETC:
        return 1528770600000;
      case MarketType.LRC:
        return 1591948800000;
    }
  }
}
