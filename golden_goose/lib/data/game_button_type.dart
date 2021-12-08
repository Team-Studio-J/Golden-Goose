import 'package:flutter/material.dart';

enum GameButtonType { long, hold, short }

extension GameButtonTypeExtension on GameButtonType {
  String get name => toString().split('.').last.toUpperCase();

  Color get color {
    switch (this) {
      case GameButtonType.long:
        return Colors.blue;
      case GameButtonType.hold:
        return Colors.grey;
      case GameButtonType.short:
        return Colors.red;
    }
  }
}
