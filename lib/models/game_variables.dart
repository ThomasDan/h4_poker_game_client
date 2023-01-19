import 'player.dart';
import 'playing_card.dart';

class GameVariables {
  int gameID;
  Player ourPlayer;
  List<Player> players;
  List<PlayingCard> cards;
  int bananasInPool;
  int currentBet = 0;
  int lastCheckPaid = 0;

  GameVariables(
    this.gameID,
    this.ourPlayer,
    this.players,
    this.cards,
    this.bananasInPool,
  );
}
