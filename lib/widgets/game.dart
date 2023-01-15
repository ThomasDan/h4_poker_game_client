import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/player.dart';
import '../models/playing_card.dart';
import './communication_manager.dart';
import './game_table.dart';

class Game extends StatefulWidget {
  final String name;

  Game(this.name, {super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late CommunicationManager cm;
  late Player player;

  @override
  // initState() is the very first thing that is run.
  void initState() {
    player = Player(widget.name);
    // super.initState() ensures that the standard initialization procedures are still run, so this is not a total @override
    super.initState();
    // https://www.flutterbeads.com/call-method-after-build-in-flutter/
    // the .addPostFrameCallback is called after the very last frame of the widget has been drawn during build()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cm = CommunicationManager();
    });
  }

  @override
  void dispose() {
    cm.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameTable(
        player,
        [
          player,
          player,
          player,
          player,
          player,
          player,
          player,
          player,
        ],
        [
          PlayingCard()
            ..suit = 'spades'
            ..value = 'ace',
          PlayingCard()
            ..suit = 'spades'
            ..value = 'ace',
        ],
        200);
  }
}
