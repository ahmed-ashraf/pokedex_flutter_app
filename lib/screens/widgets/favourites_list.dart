import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/screens/widgets/pokemon_list_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../blocs/favourites_cubit.dart';
import '../../blocs/state/favourites_state.dart';
import '../../theme/theme_colors.dart';

class FavouritesList extends StatefulWidget {
  const FavouritesList({Key? key}) : super(key: key);

  @override
  State<FavouritesList> createState() => _FavouritesListState();
}

class _FavouritesListState extends State<FavouritesList> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavouritesCubit, FavouritesState>(
        listener: (context, state) {
          if (state is NoInternetLoadMoreFavouriteState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.no_internet),
            ));
          }
        },
        builder: (context, state) {
          Widget body = const SizedBox();
          bool enablePullDown = true;
          bool enablePullUp = true;

          if (state is LoadMoreViewFavouriteState) {
            _refreshController.loadComplete();
          }

          if (state is LoadingFavouriteState) {
            enablePullDown = false;
            enablePullUp = false;
            body = const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NoInternetFavouritesState) {
            enablePullUp = false;
            body = Center(child: Text(AppLocalizations.of(context)!.no_internet),);
          } else if (state is FailedFavouriteState) {
            enablePullUp = false;
            body = Center(child: Text(AppLocalizations.of(context)!.error),);
          } else if (state is ViewFavouriteState) {
            body = GridView.builder(
              key: const Key('favouritesList'),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 700 ? 4 : 3,
                childAspectRatio: 0.6,
              ),
              itemCount: state.list.length,
              itemBuilder: (context, index) =>
                  PokemonListItem(state.list[index]),
            );
          } else if (state is NoFavouritesState) {
            enablePullUp = false;
            body = Center(child: Text(AppLocalizations.of(context)!.no_favourites),);
          }

          return Container(
            color: ThemeColors.backgroundGrey,
            padding: const EdgeInsets.only(
              left: 6,
              right: 6,
            ),
            child: SmartRefresher(
              enablePullDown: enablePullDown,
              enablePullUp: enablePullUp,
              header: const WaterDropMaterialHeader(
                  backgroundColor: Colors.white,
                  color: ThemeColors.splashBackgroundColor),
              controller: _refreshController,
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  Widget body = const SizedBox();
                  if (mode == LoadStatus.loading) {
                    body = const SizedBox(
                        height: 55.0,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: ThemeColors.splashBackgroundColor,
                        )));
                  }
                  return body;
                },
              ),
              onLoading: () {
                context.read<FavouritesCubit>().loadMore();
              },
              onRefresh: () {
                _refreshController.refreshCompleted();
                context.read<FavouritesCubit>().loadData();
              },
              child: body,
            ),
          );
        });
  }
}
