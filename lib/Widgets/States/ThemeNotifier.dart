import 'package:flutter/material.dart';
import 'package:signalr_chat/Widgets/States/GlobalTheme.dart';

class ThemeNotifier extends ChangeNotifier {
  final GlobalTheme globalTheme;

  ThemeNotifier(this.globalTheme) {
    globalTheme.addListener(notifyListeners);
  }

  @override
  void dispose() {
    globalTheme.removeListener(notifyListeners);
    super.dispose();
  }

  String get theme => globalTheme.theme;

  LinearGradient getGradient() {
    return globalTheme.getGradient();
  }

  Color getAppBarColor() {
    return theme == "default"
        ? const Color(0xFF39B0D2)
        : theme == "dark"
            ? Colors.black
            : Colors.white70;
  }

  Future<void> setTheme() async {
    await globalTheme.setTheme();
    notifyListeners();
  }

  LinearGradient? getTextBoxHeader() {
    return globalTheme.getChatTextBoxHeader();
  }
}
