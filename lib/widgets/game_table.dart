import 'package:flutter/cupertino.dart';
import 'package:h4_poker_game_client/widgets/player_controls.dart';
import 'package:h4_poker_game_client/widgets/player_seat_widget.dart';
import 'package:h4_poker_game_client/widgets/playing_card_widget.dart';
import 'package:h4_poker_game_client/widgets/raise_dialog_box.dart';
import 'package:screenshot/screenshot.dart';

import '../models/player.dart';
import '../models/playing_card.dart';

class GameTable extends StatefulWidget {
  final Player player;
  final List<Player> players;
  final List<PlayingCard> cards;
  final int bananasInPool;
  final ScreenshotController controller;

  const GameTable(this.player, this.players, this.cards, this.bananasInPool,
      this.controller,
      {super.key});

  @override
  State<GameTable> createState() => _GameTableState();
}

class _GameTableState extends State<GameTable> {
  late Player you;
  List<Player> players = [];
  List<PlayingCard> cards = [];
  int bananasInPool = 0;
  late ScreenshotController controller;
  late RaiseDialogBox raiseDialogBox;

  Row cardsPrinted() {
    List<Widget> rowCards = [];

    for (int i = 0; i < cards.length; i++) {
      rowCards.add(PlayingCardWidget(cards[i], true));
    }

    return Row(
      children: rowCards,
    );
  }

  void raise(int raiseValue) {
    // do raising
    setState(() {
      bananasInPool += raiseValue;
    });
  }

  @override
  void initState() {
    you = widget.player;
    players = widget.players;
    cards = widget.cards;
    bananasInPool = widget.bananasInPool;
    controller = widget.controller;
    raiseDialogBox = RaiseDialogBox(raise);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height / 2,
        minWidth: MediaQuery.of(context).size.width - 5,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      color: const Color.fromARGB(255, 15, 120, 15),
      child: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            // Spot for player 0 and 1
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlayerSeatWidget(players[0], false),
              const SizedBox(width: 60),
              PlayerSeatWidget(players[1], false),
            ],
          ),
          Row(
            // THe "center" row for Left players (2, 4, 6), Center Table, and Right Players (3, 5, 7)
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Left (Player 2, 4 and 6)
                children: [
                  PlayerSeatWidget(players[2], true),
                  const SizedBox(height: 35),
                  PlayerSeatWidget(players[4], true),
                  const SizedBox(height: 35),
                  PlayerSeatWidget(players[6], true),
                ],
              ),
              DragTarget<int>(
                builder: (context, _, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // Center (Table, shared)
                  children: [
                    Text(
                        '$bananasInPool ${bananasInPool <= 50 ? '🍌' : bananasInPool <= 100 ? '🍌🍌' : '🍌🍌🍌'}'),
                    cardsPrinted(),
                  ],
                ),
                onAccept: (_) => setState(() =>
                    raiseDialogBox.openRaiseDialog(10, you.bananas, context)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                // Right (Player 3, 5 and 7)
                children: [
                  PlayerSeatWidget(players[3], true),
                  const SizedBox(height: 35),
                  PlayerSeatWidget(players[5], true),
                  const SizedBox(height: 35),
                  PlayerSeatWidget(players[7], true),
                ],
              ),
            ],
          ),
          Row(
            // Spot for You
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: PlayerControls(you, controller),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
