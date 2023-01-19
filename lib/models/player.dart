import 'playing_card.dart';

class Player {
  String? name;
  String? id;
  int bananas = 0;
  List<PlayingCard> hand = [];
  bool hisTurn = false;

  Player(this.name);
}
