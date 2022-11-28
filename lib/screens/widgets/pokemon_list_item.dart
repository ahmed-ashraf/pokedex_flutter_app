import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/helpers/dominant_color.dart';
import 'package:pokedex/routes/routes.dart';
import 'package:pokedex/screens/models/pokemon_details.dart';
import 'package:pokedex/theme/theme_fonts.dart';

class PokemonListItem extends StatefulWidget {
  final PokemonDetails _pokemon;

  const PokemonListItem(this._pokemon, {Key? key}) : super(key: key);

  @override
  State<PokemonListItem> createState() => _PokemonListItemState();
}

class _PokemonListItemState extends State<PokemonListItem> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Color>(
        future: GetIt.I.get<DominantColor>().getColors(CachedNetworkImageProvider(widget._pokemon.image)),
        builder: (context, snapshot) {
          return GestureDetector(
              onTap: () => Navigator.pushNamed(context, Routes.details,
                      arguments: [
                        widget._pokemon,
                        snapshot.data ?? Colors.transparent
                      ]),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  elevation: 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Container(
                          color: snapshot.data?.withAlpha(60),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: widget._pokemon.image,
                              errorWidget: (context, _, __) => const Image(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/img.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget._pokemon.id,
                                    style: ThemeFonts.numFont,
                                  ),
                                  Text(
                                    widget._pokemon.name,
                                    style: ThemeFonts.nameFont,
                                  ),
                                ],
                              ),
                              Text(
                                widget._pokemon.types,
                                style: ThemeFonts.powerFont,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}
