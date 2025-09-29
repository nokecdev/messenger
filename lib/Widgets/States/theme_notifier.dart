import 'package:flutter/material.dart';
import 'package:signalr_chat/Widgets/States/global_theme.dart';

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

  //Used in chatrooms chatcard title
  Color getTextColor() {
    switch (theme) {
      case "dark":
        return Colors.amber;
      case "light":
        return Colors.black;
      case "default":
        return Colors.amber;
      default:
        return Colors.black;
    }
  }

  //Used for chatrooms date
   Color getSecondaryTextColor() {
    switch (theme) {
      case "dark":
        return Colors.white24;
      case "light":
        return Colors.black45;
      case "default":
        return Colors.white24;
      default:
        return Colors.black26;
    }
  }
  
  //Used in chatrooms chatcard subtitle as message
  Color getSubtitleColor() {
    switch (theme) {
      case "dark":
        return const Color.fromARGB(190, 233, 168, 16);
      case "light":
        return Colors.black54;
      case "default":
        return const Color.fromARGB(190, 233, 168, 16);
      default:
        return Colors.black26;
    }
  }


  Future<void> setTheme() async {
    await globalTheme.setTheme();
    notifyListeners();
  }

  LinearGradient? getTextBoxHeader() {
    return globalTheme.getChatTextBoxHeader();
  }
}
