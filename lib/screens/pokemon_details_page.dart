import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokedex/blocs/pokemon_mapper.dart';
import 'package:pokedex/screens/widgets/my_progress_bar.dart';
import 'package:pokedex/theme/theme_fonts.dart';

import '../blocs/favourites_cubit.dart';
import '../blocs/favourites_num_notifier.dart';
import '../blocs/pokemon_details_cubit.dart';
import '../blocs/state/pokemon_details_state.dart';
import '../theme/theme_colors.dart';
import 'models/pokemon_details.dart';

class PokemonDetailsPage extends StatelessWidget {
  final PokemonDetails _pokemonDetails;
  final Color color;

  const PokemonDetailsPage(this._pokemonDetails,
      {Key? key, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PokemonDetailsCubit>(
        create: (context) =>
            PokemonDetailsCubit()..isFavourite(_pokemonDetails.url!),
        child: PokemonDetailsPageWithoutProvider(_pokemonDetails, color: color));
  }
}

class PokemonDetailsPageWithoutProvider extends StatelessWidget {
  final PokemonDetails _pokemonDetails;
  final Color color;

  const PokemonDetailsPageWithoutProvider(this._pokemonDetails,
      {Key? key, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          BlocBuilder<PokemonDetailsCubit, PokemonDetailsState>(
              builder: (context, state) {
        if (state is IsNotFavouritePokemonDetailsState) {
          return FloatingActionButton.extended(
              backgroundColor: ThemeColors.splashBackgroundColor,
              onPressed: () {
                context.read<PokemonDetailsCubit>().addToFavourites(_pokemonDetails.url!).then((value) {
                  context.read<FavouritesCubit>().loadData();
                  context.read<FavouritesNum>().refresh();
                });
              },
              label: Text(
                AppLocalizations.of(context)!.add_favourite,
                style: const TextStyle(color: Colors.white),
              ));
        } else if (state is IsFavouritePokemonDetailsState) {
          return FloatingActionButton.extended(
            backgroundColor: ThemeColors.unfavouriteBtnColor,
            onPressed: () {
              context.read<PokemonDetailsCubit>().removeFavourite(_pokemonDetails.url!).then((value) {
                context.read<FavouritesCubit>().loadData();
                context.read<FavouritesNum>().refresh();
              });
            },
            label: Text(
              AppLocalizations.of(context)!.remove_favourites,
              style: const TextStyle(color: ThemeColors.splashBackgroundColor),
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
      backgroundColor: ThemeColors.backgroundGrey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // pinned: true,
            backgroundColor: color.withAlpha(60),
            elevation: 0,
            // stretch: true,
            // floating: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.32,
            flexibleSpace: LayoutBuilder(builder: (context, constraints) {
              var top = constraints.biggest.height;
              // print(top);
              return FlexibleSpaceBar(
                title: Opacity(
                    opacity: top < 100 ? 1.0 : 0.0,
                    child: Text(
                      _pokemonDetails.name,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                background: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        'assets/imgs/ball_details_background.svg',
                        color: color.withAlpha(90),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 16,
                      child: CachedNetworkImage(
                        height: MediaQuery.of(context).size.height * 0.32 / 2,
                        fit: BoxFit.cover,
                        errorWidget: (context, _, __) => const Image(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/img.png'),
                        ),
                        imageUrl: _pokemonDetails.image,
                        placeholder: (context, url) => const Image(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/img.png'),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.32 / 2,
                          ),
                          Text(
                            _pokemonDetails.name,
                            style: ThemeFonts.pokemonDetailTitle,
                          ),
                          Text(
                            _pokemonDetails.types,
                            style: ThemeFonts.pokemonDetailTypes,
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        left: 16,
                        bottom: 14,
                        child: Text(
                          _pokemonDetails.id,
                          style: ThemeFonts.pokemonDetailTypes,
                        ))
                  ],
                ),
              );
            }),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.height,
                          style: ThemeFonts.powerFont500,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          _pokemonDetails.height.toString(),
                          style: ThemeFonts.pokemonDetailTypes14,
                        )
                      ]),
                  const SizedBox(
                    width: 48,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.weight,
                          style: ThemeFonts.powerFont500,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          _pokemonDetails.weight.toString(),
                          style: ThemeFonts.pokemonDetailTypes14,
                        )
                      ]),
                  const SizedBox(
                    width: 48,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.bmi,
                          style: ThemeFonts.powerFont500,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          _pokemonDetails.bmi.toPrecision(2).toString(),
                          style: ThemeFonts.pokemonDetailTypes14,
                        )
                      ]),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              color: Colors.white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 16, right: 16),
                      child: Text(
                        AppLocalizations.of(context)!.base_stats,
                        style: ThemeFonts.pokemonDetailTypes600,
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    _powerPercentWidget(AppLocalizations.of(context)!.hp, _pokemonDetails.hp),
                    const SizedBox(
                      height: 24,
                    ),
                    _powerPercentWidget(AppLocalizations.of(context)!.attack, _pokemonDetails.attack),
                    const SizedBox(
                      height: 24,
                    ),
                    _powerPercentWidget(AppLocalizations.of(context)!.defense, _pokemonDetails.defense),
                    const SizedBox(
                      height: 24,
                    ),
                    _powerPercentWidget(
                        AppLocalizations.of(context)!.special_attack, _pokemonDetails.specialAttach),
                    const SizedBox(
                      height: 24,
                    ),
                    _powerPercentWidget(
                        AppLocalizations.of(context)!.special_defense, _pokemonDetails.specialDefense),
                    const SizedBox(
                      height: 24,
                    ),
                    _powerPercentWidget(AppLocalizations.of(context)!.speed, _pokemonDetails.speed),
                    const SizedBox(
                      height: 24,
                    ),
                    _powerPercentWidget(
                        AppLocalizations.of(context)!.avg_power, _pokemonDetails.getAvgPower()),
                    const SizedBox(
                      height: 24,
                    ),
                  ]),
            ),
            const SizedBox(
              height: 100,
            )
          ]))
        ],
      ),
    );
  }

  _powerPercentWidget(String name, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                name,
                style: ThemeFonts.powerFont14,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                value.toString(),
                style: ThemeFonts.pokemonDetailTypes500,
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          MyProgressBar(max: 100, current: value)
        ],
      ),
    );
  }
}
