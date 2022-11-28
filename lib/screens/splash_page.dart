import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/theme/theme_colors.dart';
import 'package:pokedex/theme/theme_fonts.dart';

import '../routes/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.home,
        (route) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ThemeColors.splashBackgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/imgs/icon.svg',
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.pokemon.toUpperCase(),
                  style: ThemeFonts.splashHeaderFont,
                ),
                Text(
                  AppLocalizations.of(context)!.app_name,
                  style: ThemeFonts.splashAppNameFont,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
