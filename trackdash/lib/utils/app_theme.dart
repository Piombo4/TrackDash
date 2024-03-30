import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(186, 242, 70, 1.0),
  100: Color.fromRGBO(186, 242, 70, .2),
  200: Color.fromRGBO(186, 242, 70, .3),
  300: Color.fromRGBO(186, 242, 70, .4),
  400: Color.fromRGBO(186, 242, 70, .5),
  500: Color.fromRGBO(186, 242, 70, .6),
  600: Color.fromRGBO(186, 242, 70, .7),
  700: Color.fromRGBO(186, 242, 70, .8),
  800: Color.fromRGBO(186, 242, 70, .9),
  900: Color.fromRGBO(186, 242, 70, 1.0),
};
ThemeData app_theme = ThemeData(
    textTheme: const TextTheme(
        titleMedium:
            TextStyle(color: Color(0xff1a1c1f), fontWeight: FontWeight.bold),
        bodySmall: TextStyle(color: Color(0xadf6f8f9)),
        bodyLarge: TextStyle(color: Color(0xfff6f8f9)),
        displayLarge: TextStyle(color: Color(0xfff6f8f9)),
        bodyMedium: TextStyle(color: Color(0xfff6f8f9)),
        displayMedium: TextStyle(color: Color(0xfff6f8f9))),
    indicatorColor: Color(0xffbaf246),
    cardTheme: CardTheme(
        color: Color(0xff1a1c1f),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0), //<-- SEE HERE
          side: const BorderSide(
            color: Colors.amber,
          ),
        )),
    colorScheme: ColorScheme(
      outlineVariant: Color.fromARGB(255, 66, 66, 66),
      scrim: Color(0xffbaf246),
      brightness: Brightness.dark,
      primary: Color(0xffbaf246),
      onPrimary: Color(0xfff6f8f9),
      primaryContainer: Color(0xff1a2c42),
      onPrimaryContainer: Color(0xffe3e6ea),
      secondary: Color(0xffc9f56e),
      onSecondary: Color(0xffe3e6ea),
      secondaryContainer: Color(0xffd48608),
      onSecondaryContainer: Color(0xfffff4e1),
      tertiary: Color(0xffcbee85),
      onTertiary: Color(0xff14130d),
      tertiaryContainer: Color(0xff8fc029),
      onTertiaryContainer: Color(0xfffef6e6),
      error: Color(0xffcf6679),
      onError: Color(0xff140c0d),
      errorContainer: Color(0xffb1384e),
      onErrorContainer: Color(0xfffbe8ec),
      background: Color(0xff151618),
      onBackground: Color(0xffececec),
      surface: Color(0xff2a2a2a),
      //default background dei button
      onSurface: Color(0xffececec),
      surfaceVariant: Color(0xff1a1c1f),
      onSurfaceVariant: Color(0xffdbdbdb),
      outline: Color(0xffa0a0a0),
      shadow: Color(0xff000000),
      inverseSurface: Color(0xfff5f6f8),
      onInverseSurface: Color(0xff131313),
      inversePrimary: Color(0xff38404a),
      surfaceTint: Color(0xff60748a),
    ));
