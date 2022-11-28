import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/screens/widgets/favourites_list.dart';
import 'package:pokedex/screens/widgets/pokemons_list.dart';
import 'package:pokedex/theme/theme_colors.dart';
import 'package:provider/provider.dart';

import '../blocs/favourites_num_notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/imgs/appbar_icon.svg',
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                AppLocalizations.of(context)!.app_name,
              ),
            ],
          ),
          // bottomOpacity: 0.5,
          bottom: TabBar(
            labelColor: Colors.black,
            // unselectedLabelColor: ThemeColors.marine,
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            labelStyle: const TextStyle(
              fontSize: 16,
            ),
            indicatorColor: ThemeColors.splashBackgroundColor,
            indicatorWeight: 4,
            tabs: [
              Tab(
                text: AppLocalizations.of(context)!.all_pokemons,
              ),
              Tab(
                key: const Key('favouritesTap'),
                child: Consumer<FavouritesNum>(
                    builder: (context, favCount, child) {
                  if (favCount.num == 0) {
                    return Text(AppLocalizations.of(context)!.favourites);
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.favourites),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        key: const Key('favCount'),
                        padding: const EdgeInsets.all(3.5),
                        decoration: BoxDecoration(
                          color: ThemeColors.splashBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          favCount.num.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PokemonsList(),
            FavouritesList(),
          ],
        ),
      ),
    );
  }
}
