# Pokedex App

This app uses https://pokeapi.co

## Notes

- bloc is used as state management
- dio is used of api requests
- unit testing and integration testing are implemented


https://user-images.githubusercontent.com/19362719/205480599-1b8a9c08-beab-4f3d-8d60-3b7680ef0870.mp4


## Used packages

- google_fonts
- get_it
- dartz
- flutter_bloc
- json_annotation
- json_serializable
- dio
- pull_to_refresh
- flutter_svg
- cached_network_image
- connectivity
- shared_preferences
- equatable
- provider
#### For testing
- mocktail
- bloc_test
- integration_test
- flutter_test

## File structure
- main.dart
  - In this file MyApp will be created and initialized.
  - Repositories is registered in GetIt before runApp.
  - MultiProvider is used to inject providers that has to be accessed through the whole app.
- screens
  - Our three different pages (Splash, Home, Pokemon details).
  - Widgets - Some reusable widgets.
    - MyProgressBar - This is a custom animated horizonal line progress bar (Color is changed based on value).
  - routes
    - route_generator - It has generateRoute function
    - routes - All routes of the app encapsulated here for easy access.
  - repository
    - FavouritesRepository - used to store favorites persistently.
    - PokemonsRepository - used to get data from API.
      - Dio is used here to handle requested. The dio object will need to be injected to it. (To add interceptor for example).
      - Either is used from dartz for efficient error handling.
  - network
    - AppInterceptor - for logging data in debug mode.
    - RetryOnConnectionChangeInterceptor - this can be used to retry request if the phone reconnects to the internet.
    - errors - Common network failures.
  - helpers
    - capitalize - an extension for String to make capitalize first Char.
    - DominantColor - to get the dominant color from a rectangle of 40x40 px in the middle of the image.
  - blocs - flutter_bloc is used for state management
    - FavouritesCubit
    - PokemonsListCubit
    - pokemon_mapper - This is used to map pokemons from api responses to pokemons list that can be used in our ui.
    - PokemonDetailsCubit - this is used to add and remove from favorites.
    - FavouritesNum - this is a ChangeNotifier that is used to notify the UI of the change of favorites count.

### Unit testing
- image_mock_http_client - This is used to mock the image requests and respond with a fake image while unit testing.
- test_helpers
  - fixtures - This is a function that is used to read json files to mock API responses. (json files are located under test_resources).
  - screens-> widgets
    - favourites_list_test - Testing favorites list widget.
    - pokemons_list_test - Testing Pokemons list.
  - blocs - Testing blocs with bloc_test lib.
  - data - Some fake data to use when testing screens.

### Integration test

- app_test - The whole app is tested here (pagination - add/remove favorite - scroll performance)
