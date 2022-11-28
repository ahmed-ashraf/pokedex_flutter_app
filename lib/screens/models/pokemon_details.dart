import 'package:equatable/equatable.dart';

class PokemonDetails extends Equatable {
  String name;
  int _id;

  String image;

  String types;

  int height;
  int weight;
  double bmi;

  int hp;
  int attack;
  int defense;

  int specialAttach;
  int specialDefense;
  int speed;

  String? url;

  @override
  List<Object> get props => [_id];

  PokemonDetails(this._id,
      {required this.name,
      required this.image,
      required this.types,
      required this.height,
      required this.weight,
      required this.bmi,
      required this.hp,
      required this.attack,
      required this.defense,
      required this.specialAttach,
      required this.specialDefense,
      required this.speed,
        this.url});




  int getAvgPower() {
    return (hp + attack + defense + specialAttach + specialDefense + speed) ~/ 6;
  }

  String get id {
    if (_id.toString().length == 1) {
      return '#00$_id';
    } else if (_id.toString().length == 2) {
      return '#0$_id';
    } else if (_id.toString().length == 3) {
      return '#$_id';
    }
    return '#$_id';
  }
}
