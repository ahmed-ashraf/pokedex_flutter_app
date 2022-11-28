import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/helpers/dominant_color.dart';
import 'package:pokedex/repository/favourites_repository.dart';
import 'package:pokedex/repository/pokemons_repository.dart';
import 'package:pokedex/screens/splash_page.dart';
import 'package:pokedex/theme/theme_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'blocs/favourites_cubit.dart';
import 'blocs/favourites_num_notifier.dart';
import 'blocs/pokemons_list_cubit.dart';
import 'network/app_intercepor.dart';
import 'routes/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupRepositories();

  GetIt.I.registerLazySingleton<DominantColor>(() => DominantColor());

  runApp(const MyApp());
}

setupRepositories() async {
  Dio dio = Dio();
  if (kDebugMode) dio.interceptors.add(AppInterceptor());

  GetIt.I.registerLazySingleton<PokemonsRepository>(() => PokemonsRepository(dio));
  GetIt.I.registerSingleton<FavouritesRepository>(await FavouritesRepository.create());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavouritesNum>(
          create: (context) => FavouritesNum()..refresh(),
        ),
        BlocProvider<PokemonsListCubit>(
          create: (context) => PokemonsListCubit()..loadData(),
        ),
        BlocProvider<FavouritesCubit>(
          create: (context) => FavouritesCubit()..loadData(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          fontFamily: GoogleFonts.notoSans().fontFamily,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
                fontSize: 20,
                color: ThemeColors.titleFontColor,
                fontWeight: FontWeight.bold),
            iconTheme: IconThemeData(color: Colors.black54),
          ),
          primarySwatch: Colors.blue,
        ),
        home: const SplashPage(),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
