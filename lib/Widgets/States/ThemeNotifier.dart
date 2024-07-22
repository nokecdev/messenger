import 'package:flutter/material.dart';
import 'package:signalr_chat/Widgets/States/GlobalTheme.dart';

class ThemeNotifier extends ChangeNotifier {
  final GlobalTheme globalTheme;

  ThemeNotifier(this.globalTheme);

  String get theme => globalTheme.theme;

  LinearGradient getGradient() {
    return globalTheme.getGradient();
  }

  Future<void> setTheme() async {
    await globalTheme.setTheme();
    notifyListeners();
  }
}
