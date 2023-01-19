import 'package:flutter/cupertino.dart';
import 'package:screenshot/screenshot.dart';

import './player_controls.dart';
import './player_seat_widget.dart';
import './playing_card_widget.dart';
import './raise_dialog_box.dart';

import '../models/player_action_methods.dart';
import '../models/game_variables.dart';

class GameTable extends StatefulWidget {
  final GameVariables gameVariables;
  final PlayerActionMethods actionMethods;

  final ScreenshotController screenShotController;

  const GameTable(
      this.gameVariables, this.actionMethods, this.screenShotController,
      {super.key});

  @override
  State<GameTable> createState() => _GameTableState();
}

class _GameTableState extends State<GameTable> {
  late GameVariables gameVariables;
  late PlayerActionMethods actionMethods;
  late ScreenshotController screenShotController;
  late RaiseDialogBox raiseDialogBox;

  Row cardsPrinted() {
    List<Widget> rowCards = [];

    for (int i = 0; i < gameVariables.cards.length; i++) {
      rowCards.add(PlayingCardWidget(gameVariables.cards[i], true));
    }

    return Row(
      children: rowCards,
    );
  }

  @override
  void initState() {
    gameVariables = widget.gameVariables;
    actionMethods = widget.actionMethods;
    screenShotController = widget.screenShotController;
    raiseDialogBox = RaiseDialogBox(actionMethods.raise);
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
      color: const Color.fromARGB(255, 14, 102, 14),
      child: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            // Spot for player 0 and 1
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlayerSeatWidget(gameVariables.players[0], false),
              const SizedBox(width: 60),
              PlayerSeatWidget(gameVariables.players[1], false),
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
                  PlayerSeatWidget(gameVariables.players[2], true),
                  const SizedBox(height: 35),
                  PlayerSeatWidget(gameVariables.players[4], true),
                  const SizedBox(height: 35),
                  PlayerSeatWidget(gameVariables.players[6], true),
                ],
              ),
              // DragTarget has a type int, and that's because DragTarget and Dragable will cause an exception if theres no data.
              DragTarget<int>(
                builder: (context, _, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // Center (Table, shared)
                  children: [
                    Text(
                        '${gameVariables.bananasInPool} ${gameVariables.bananasInPool <= 90 ? '🍌' : gameVariables.bananasInPool <= 180 ? '🍌🍌' : '🍌🍌🍌'}'),
                    cardsPrinted(),
                  ],
                ),
                onAccept: (_) => setState(() => raiseDialogBox.openRaiseDialog(
                    10, gameVariables.ourPlayer.bananas, context)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                // Right (Player 3, 5 and 7)
                children: [
                  PlayerSeatWidget(gameVariables.players[3], true),
                  const SizedBox(height: 35),
                  PlayerSeatWidget(gameVariables.players[5], true),
                  const SizedBox(height: 35),
                  PlayerSeatWidget(gameVariables.players[7], true),
                ],
              ),
            ],
          ),
          Row(
            // Spot for You
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: PlayerControls(gameVariables.ourPlayer, actionMethods,
                    screenShotController),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
