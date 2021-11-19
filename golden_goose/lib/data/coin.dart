enum Coin {
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

extension CoinExtension on Coin {
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
      case Coin.BTC:
        return "Bitcoin";
      case Coin.ETH:
        return "Ethereum";
      case Coin.BNB:
        return "Binance";
      case Coin.ADA:
        return "Cardano";
      case Coin.XRP:
        return "Ripple";
      case Coin.DOT:
        return "Polkadot";
      case Coin.DOGE:
        return "Doge";
      case Coin.LTC:
        return "Litecoin";
      case Coin.BCH:
        return "Bitcoin Cash";
      case Coin.ETC:
        return "Ethereum Classic";
      case Coin.LRC:
        return "Loopring";
      case Coin.EOS:
        return "EOS";
    }
  }

  int get firstTime {
    switch (this) {
      case Coin.BTC:
        return 1502942400000;
      case Coin.ETH:
        return 1502942400000;
      case Coin.EOS:
        return 1527483600000;
      case Coin.XRP:
        return 1525421460000;
      case Coin.DOT:
        return 1597791600000;
      case Coin.BNB:
        return 1509940440000;
      case Coin.ADA:
        return 1523937720000;
      case Coin.DOGE:
        return 1562328000000;
      case Coin.LTC:
        return 1513135920000;
      case Coin.BCH:
        return 1574935200000;
      case Coin.ETC:
        return 1528770600000;
      case Coin.LRC:
        return 1591948800000;
    }
  }
}
