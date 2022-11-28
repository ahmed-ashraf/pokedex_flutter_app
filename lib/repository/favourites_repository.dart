import 'package:shared_preferences/shared_preferences.dart';

class FavouritesRepository {
  late final SharedPreferences _prefs;

  static Future<FavouritesRepository> create() async {
    FavouritesRepository favouritesRepository = FavouritesRepository();
    await favouritesRepository._init();
    return favouritesRepository;
  }

  _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future addToFavourites(String url) async {
    List<String> savedItems = _prefs.getStringList('savedItems') ?? [];

    savedItems.add(url);
    await _prefs.setStringList('savedItems', savedItems);
  }

  int getCount() {
    List<String> savedItems = _prefs.getStringList('savedItems') ?? [];
    return savedItems.length;
  }

  Future<List<String>> getPage(int page) async {
    List<String> savedItems = _prefs.getStringList('savedItems') ?? [];
    if (savedItems.length > page * 10 + 10) {
      return savedItems.getRange(page * 10, page * 10 + 10).toList();
    } else {
      if (page * 10 > savedItems.length - 1) return [];
      return savedItems.getRange(page * 10, savedItems.length).toList();
    }
  }

  removeFromFavourites(String url) async {
    List<String> savedItems = _prefs.getStringList('savedItems') ?? [];
    await _prefs.setStringList(
        'savedItems', savedItems.where((value) => url != value).toList());
  }

  Future<bool> isFavourite(String url) async {
    List<String> savedItems = _prefs.getStringList('savedItems') ?? [];
    return savedItems.contains(url);
  }

  Future clear() async {
    await _prefs.setStringList('savedItems', []);
  }
}
