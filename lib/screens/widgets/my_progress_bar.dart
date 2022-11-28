import 'package:flutter/material.dart';
import 'package:pokedex/theme/theme_colors.dart';

class MyProgressBar extends StatelessWidget {
  final double max;
  final int current;

  const MyProgressBar(
      {Key? key,
        required this.max,
        required this.current})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        var percent = (current / max) * x;
        return Stack(
          children: [
            Container(
              width: x,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xffd3d3d3),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: 0,
                  end: percent,
                ),
                duration: const Duration(
                    milliseconds: 500),
              builder: (context, value, _) {
                return Container(
                  width: value,
                  height: 4,
                  decoration: BoxDecoration(
                    color: getColor(current),
                    borderRadius: BorderRadius.circular(25),
                  ),
                );
              }
            ),
          ],
        );
      },
    );
  }

  getColor(int value) {
    if (value <= 30) {
      return ThemeColors.lowProgressBar;
    } else if (value <= 70) {
      return ThemeColors.mediumProgressBar;
    } else {
      return ThemeColors.highProgressBar;
    }
  }
}