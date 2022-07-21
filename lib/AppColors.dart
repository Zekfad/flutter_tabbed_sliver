import 'package:flutter/material.dart';


/// App colors helper with themes support.
class AppColors {
  String theme = 'light';

  /// Main colors map
  static const Map<String, Map<String, Color>> colors = {
    'light': <String, Color>{
      'black': Color(0xFF212121),
      'grayDark': Color(0xFF8A8A8F),
      'gray': Color(0xFFB3B3B3),
      'grayLight': Color(0xFFD8D8D8),
      'background': Color(0xFFF8F9FA),
      'white': Color(0xFFFFFFFF),
      'blue': Color(0xFF5AC8FA),
      'gold': Color(0xFFFCDDA7),
      'shadow': Color(0x3DB0BEC5),
    },
    'dark': <String, Color>{
    },
  };

  /// Toggle current theme.
  void toggleTheme() {
    theme = isDark() ? 'light' : 'dark';
  }

  bool isDark() => theme == 'dark';
  bool isLight() => theme == 'light';

  static const primaryLightAccent = Color(0xFF5AC8FA);
  static const primaryDarkAccent = Color(0xFF5AC8FA);

  /// Get current theme color by name or black color if none was found.
  Color getColor(String name) => colors[theme]?[name] ?? Colors.black;

  Color get lightWhite => colors['light']?['white'] ?? Colors.white;
  Color get lightBlack => colors['light']?['black'] ?? Colors.black;

  Color get black => getColor('black');
  Color get grayDark => getColor('grayDark');
  Color get gray => getColor('gray');
  Color get grayLight => getColor('grayLight');
  Color get background => getColor('background');
  Color get white => getColor('white');
  Color get blue => getColor('blue');
  Color get gold => getColor('gold');
  Color get shadow => getColor('shadow');
}

final AppColors colors = AppColors();