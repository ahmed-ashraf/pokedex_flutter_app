import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../repository/favourites_repository.dart';

class FavouritesNum extends ChangeNotifier {
  int num = 0;

  refresh() {
    num = GetIt.I.get<FavouritesRepository>().getCount();
    notifyListeners();
  }
}