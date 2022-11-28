import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pokedex/theme/theme_colors.dart';

class ThemeFonts {
  static const splashHeaderFont = TextStyle(color: Colors.white, fontSize: 16);
  static const numFont = TextStyle(color: Color(0xff6B6B6B), fontSize: 12);
  static const nameFont = TextStyle(color: Color(0xf0000000), fontSize: 14, fontWeight: FontWeight.w600);
  static const powerFont = TextStyle(color: Color(0xff6B6B6B), fontSize: 12, fontWeight: FontWeight.w400);
  static const powerFont14 = TextStyle(color: Color(0xff6B6B6B), fontSize: 14, fontWeight: FontWeight.w400);
  static const powerFont500 = TextStyle(color: Color(0xff6B6B6B), fontSize: 12, fontWeight: FontWeight.w500);
  static const pokemonDetailTitle = TextStyle(color: ThemeColors.titleFontColor, fontSize: 32, fontWeight: FontWeight.w700);
  static const pokemonDetailTypes = TextStyle(color: ThemeColors.titleFontColor, fontSize: 16, fontWeight: FontWeight.w400);
  static const pokemonDetailTypes600 = TextStyle(color: ThemeColors.titleFontColor, fontSize: 16, fontWeight: FontWeight.w600);
  static const pokemonDetailTypes14 = TextStyle(color: ThemeColors.titleFontColor, fontSize: 14, fontWeight: FontWeight.w400);
  static const pokemonDetailTypes500 = TextStyle(color: ThemeColors.titleFontColor, fontSize: 14, fontWeight: FontWeight.w500);
  static const splashAppNameFont =
      TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold);
}
