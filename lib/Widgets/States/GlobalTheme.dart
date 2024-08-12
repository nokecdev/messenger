import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:signalr_chat/Storage/UserStorage.dart';

class GlobalTheme with ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  UserStorage userStorage = UserStorage();

  String _theme = "default";

  GlobalTheme() {
    _loadTheme();
  }

  String get theme => _theme;

  Future<void> _loadTheme() async {
    _theme = await storage.read(key: "theme") ?? "default";
    print("theme is : " + theme);
    notifyListeners();
  }

  Future<void> setTheme() async {
    switch (_theme) {
      case "dark":
        _theme = "light";
        break;
      case "light":
        _theme = "default";
        break;
      case "default":
        _theme = "dark";
        break;
      default:
        _theme = "default";
        break;
    }
    await storage.write(key: "theme", value: _theme);
    notifyListeners();
  }

  LinearGradient getGradient() {
    switch (_theme) {
      case "dark":
        return darkBackgroundGradient;
      case "light":
        return lightBackgroundGradient;
      case "default":
        return defaultBackgroundGradient;
      default:
        return defaultBackgroundGradient;
    }
  }

  LinearGradient getChatTextBoxHeader() {
    switch (_theme) {
      case "dark":
        return textBoxHeaderDark;
      case "light":
        return textBoxHeaderLight;
      case "default":
        return textBoxHeaderDefault;
      default:
        return textBoxHeaderDefault;
    }
  }

  static ThemeData baseTheme(
      LinearGradient backgroundGradient, Color focusColor) {
    return ThemeData(
      primarySwatch: Colors.blue,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.black)),
      extensions: [
        CustomTheme(backgroundGradient: backgroundGradient),
      ],
    );
  }

  static final Color _defaultFocusColor =
      const Color.fromARGB(255, 122, 86, 206).withOpacity(0.12);
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData defaultTheme =
      baseTheme(defaultBackgroundGradient, _defaultFocusColor);
  static ThemeData lightTheme =
      baseTheme(lightBackgroundGradient, _lightFocusColor);
  static ThemeData darkTheme =
      baseTheme(darkBackgroundGradient, _darkFocusColor);

  static const LinearGradient defaultBackgroundGradient = LinearGradient(
    colors: [Color(0xFF39B0D2), Color(0xFF8277EE)],
    stops: [0, 1],
    begin: AlignmentDirectional(0, -1),
    end: AlignmentDirectional(0, 1),
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 227, 230, 231),
      Color.fromARGB(255, 219, 219, 223)
    ],
    stops: [0, 1],
    begin: AlignmentDirectional(0, -1),
    end: AlignmentDirectional(0, 1),
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [Color.fromARGB(255, 13, 5, 20), Color.fromARGB(255, 34, 34, 34)],
    stops: [0, 1],
    begin: AlignmentDirectional(0, -1),
    end: AlignmentDirectional(0, 1),
  );

  static const LinearGradient textBoxHeaderDefault = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.1, 0.4, 0.9],
    colors: [
      Color.fromARGB(87, 231, 229, 255),
      Color.fromARGB(88, 98, 90, 170),
      Colors.transparent,
    ],
  );

  static const LinearGradient textBoxHeaderDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0, 0.4, 0.9],
    colors: [
      Color.fromARGB(255, 0, 0, 0),
      Color.fromARGB(164, 36, 35, 35),
      Color.fromARGB(200, 0, 0, 0),
    ],
  );

  static const LinearGradient textBoxHeaderLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.1, 0.4, 0.9],
    colors: [
      Color.fromARGB(255, 165, 165, 168),
      Color.fromARGB(86, 233, 233, 233),
      Color.fromARGB(255, 187, 187, 187),
    ],
  );
}

class CustomTheme extends ThemeExtension<CustomTheme> {
  final LinearGradient? backgroundGradient;

  CustomTheme({this.backgroundGradient});

  @override
  CustomTheme copyWith({LinearGradient? backgroundGradient}) {
    return CustomTheme(
        backgroundGradient: backgroundGradient ?? this.backgroundGradient);
  }

  @override
  CustomTheme lerp(ThemeExtension<CustomTheme>? other, double t) {
    if (other is! CustomTheme) return this;
    return CustomTheme(
      backgroundGradient:
          LinearGradient.lerp(backgroundGradient, other.backgroundGradient, t),
    );
  }
}
