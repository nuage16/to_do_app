import 'package:flutter/material.dart';

class CustomMaterialColor {
  static const MaterialColor defaultSwatch = MaterialColor(
    0xff4CAF50, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffE8F5E9), //10%
      100: Color(0xffC8E6C9), //20%
      200: Color(0xffA5D6A7), //30%
      300: Color(0xff81C784), //40%
      400: Color(0xff66BB6A), //50%
      500: Color(0xff4CAF50), //60%
      600: Color(0xff43A047), //70%
      700: Color(0xff388E3C), //80%
      800: Color(0xff2E7D32), //90%
      900: Color(0xff1B5E20), //100%
    },
  );

  // ThemeData _joyTheme = ThemeData(
  //   primaryColor: CustomMaterialColor.joySwatch.shade200,
  //   shadowColor: CustomMaterialColor.joySwatch.shade100,
  //   floatingActionButtonTheme: FloatingActionButtonThemeData(
  //     backgroundColor: CustomMaterialColor.joySwatch.shade200,
  //   ),
  //   elevatedButtonTheme: ElevatedButtonThemeData(
  //       style: ElevatedButton.styleFrom(
  //     primary: CustomMaterialColor.joySwatch.shade200,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //   )),
  //   colorScheme: ColorScheme.fromSwatch()
  //       .copyWith(secondary: CustomMaterialColor.joySwatch.shade50),
  // );

}
