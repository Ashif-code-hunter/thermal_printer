import 'package:flutter/material.dart';
import 'package:untitled/constants/style_manager.dart';

import 'color_manger.dart';
import 'font_manager.dart';

ThemeData getApplicationTheme() {

   return ThemeData.light(useMaterial3: true).copyWith(
       textTheme: TextTheme(
         displayLarge: getSemiBoldStyle(
             color: ColorManager.black, fontSize: FontSize.s60),
         displayMedium: getRegularStyle(
             color: ColorManager.black, fontSize: FontSize.s36),
         displaySmall:
         getBoldStyle(color: ColorManager.black, fontSize: FontSize.s30),
         headlineMedium: getBoldStyle(
             color: ColorManager.black, fontSize: FontSize.s24),
         headlineSmall:getRegularStyle(
             color: ColorManager.black, fontSize: FontSize.s14),
         titleLarge: getBoldStyle(
             color: ColorManager.black, fontSize: FontSize.s20),
         titleMedium: getBoldStyle(
             color: ColorManager.black, fontSize: FontSize.s18),
         titleSmall: getRegularStyle(
             color: ColorManager.black, fontSize: FontSize.s16),
       ),
        colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: ColorManager.primaryLight,
            onPrimary:   ColorManager.onPrimaryLight,
            secondary: ColorManager.onSecondary,
            onSecondary: ColorManager.onSecondary,
            error: ColorManager.error,
            onError: ColorManager.onError,
            background: ColorManager.background,
            onBackground:ColorManager.onBackground,
            surface: ColorManager.surfaceLight,
            onSurface: ColorManager.white));


}
