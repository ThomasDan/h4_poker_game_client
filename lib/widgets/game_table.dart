import 'package:flutter/cupertino.dart';
import 'package:h4_poker_game_client/widgets/player_widget.dart';

import '../models/player.dart';
import '../models/playing_card.dart';

class GameTable extends StatefulWidget {
  final Player player;
  final List<Player> players;
  final List<PlayingCard> cards;
  final int bananasInPool;

  GameTable(this.player, this.players, this.cards, this.bananasInPool,
      {super.key});

  @override
  State<GameTable> createState() => _GameTableState();
}

class _GameTableState extends State<GameTable> {
  late Player you;
  List<Player> players = [];
  List<PlayingCard> cards = [];
  int bananasInPool = 0;

  @override
  void initState() {
    you = widget.player;
    players = widget.players;
    cards = widget.cards;
    bananasInPool = widget.bananasInPool;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // Spot for player 0 and 1
          children: [
            players[0] != null ? PlayerWidget(players[0]) : Text('Open Seat'),
            players[1] != null ? PlayerWidget(players[1]) : Text('Open Seat'),
          ],
        ),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // THe "center" column for Left players (2, 4, 6), Center Table, and Right Players (3, 5, 7)
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Left (Player 2, 4 and 6)
                  children: [
                    players[2] != null
                        ? PlayerWidget(players[2])
                        : Text('Open Seat'),
                    players[4] != null
                        ? PlayerWidget(players[4])
                        : Text('Open Seat'),
                    players[6] != null
                        ? PlayerWidget(players[6])
                        : Text('Open Seat'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // Center (Table, shared)
                  children: [
                    Text('$bananasInPool Bananas'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // Right (Player 3, 5 and 7)
                  children: [
                    players[3] != null
                        ? PlayerWidget(players[3])
                        : Text('Open Seat'),
                    players[5] != null
                        ? PlayerWidget(players[5])
                        : Text('Open Seat'),
                    players[7] != null
                        ? PlayerWidget(players[7])
                        : Text('Open Seat'),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          // Spot for You
          children: [],
        ),
      ],
    );
  }
}
