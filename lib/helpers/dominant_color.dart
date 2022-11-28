import 'package:flutter/material.dart';
import 'package:pokedex/helpers/palette_generator.dart';


class DominantColor {
  Future<Color> getColors(ImageProvider imageProvider) async {
    PaletteGenerator paletteGenerator;
    paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
    Color dominantColor = paletteGenerator.dominantColor?.color ?? Colors.white;
    return dominantColor;
  }
}
