import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../models/player.dart';
import '../models/game_variables.dart';
import '../models/player_action_methods.dart';
import '../models/playing_card.dart';
import './communication_manager.dart';
import './game_table.dart';

class Game extends StatefulWidget {
  final String name;

  const Game(this.name, {super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late CommunicationManager cm;

  late GameVariables gameVariables;
  final screenShotController = ScreenshotController();
  late PlayerActionMethods actionMethods;

  packJSONAction(String action, {String jsonValues = ''}) {
    return jsonEncode(
        '{"type":"action", "gameID": "${gameVariables.gameID}","action":"$action"${jsonValues != '' ? ',$jsonValues' : ''}}');
  }

  checkOrCall() {
    // Call check
    if (gameVariables.currentBet > gameVariables.lastCheckPaid &&
        gameVariables.currentBet <= gameVariables.ourPlayer.bananas) {
      cm.outgoingMessage(packJSONAction('call'));
    }
    // Check check
    else if (gameVariables.lastCheckPaid == gameVariables.currentBet) {
      cm.outgoingMessage(packJSONAction('check'));
    }
  }

  raise(int attemptedBet) {
    if (gameVariables.ourPlayer.bananas > attemptedBet &&
        gameVariables.currentBet < attemptedBet) {
      cm.outgoingMessage(
          packJSONAction('raise', jsonValues: '"bet":"$attemptedBet"'));
    }
  }

  allIn() {
    if (gameVariables.ourPlayer.bananas > 0) {
      cm.outgoingMessage(packJSONAction('bet',
          jsonValues: '"bet":"${gameVariables.ourPlayer.bananas}"'));
    }
  }

  fold() {
    cm.outgoingMessage(packJSONAction('fold'));
  }

  quit() {
    // somehow destroy this widget..??? deactivate(), ..maybe?
  }

  handleMessage(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'connect':
        print('Player ID received: ${json['id']}');
        gameVariables.ourPlayer.id = json['id'];
        break;

      default:
        print('Unhandled Message Type:\n${json.toString()}');
        break;
    }
  }

  @override
  // initState() is the very first thing that is run.
  void initState() {
    Player ourPlayer = Player(widget.name)
      ..bananas = 100
      ..id = '39449'
      ..hand = [
        PlayingCard()
          ..suit = 'clubs'
          ..value = '8',
        PlayingCard()
          ..suit = 'diamonds'
          ..value = 'king',
      ];

    actionMethods = PlayerActionMethods(checkOrCall, raise, allIn, fold, quit);

    gameVariables = GameVariables(
      0,
      ourPlayer,
      [
        Player('TOmmy')
          ..bananas = 10
          ..hand = [
            PlayingCard()
              ..suit = 'hearts'
              ..value = 'king',
            PlayingCard()
              ..suit = 'hearts'
              ..value = 'queen',
          ]
          ..id = '1231',
        Player('Jonny')
          ..bananas = 34
          ..id = '1337'
          ..hand = [
            PlayingCard(),
            PlayingCard(),
          ],
        Player('Jimmy')
          ..bananas = 5555
          ..id = '100'
          ..hand = [
            PlayingCard()
              ..suit = 'clubs'
              ..value = 'jack',
            PlayingCard(),
          ],
        ourPlayer,
        ourPlayer,
        ourPlayer,
        ourPlayer,
        Player('Kimmy')
          ..bananas = 69
          ..id = '12314'
          ..hand = [
            PlayingCard(),
            PlayingCard(),
          ],
      ],
      [
        PlayingCard()
          ..suit = 'spades'
          ..value = 'ace',
        PlayingCard()
          ..suit = 'spades'
          ..value = 'ace',
        PlayingCard()
          ..suit = 'spades'
          ..value = 'ace',
        PlayingCard()
          ..suit = 'spades'
          ..value = 'ace',
        PlayingCard(),
      ],
      200,
    );

    // super.initState() ensures that the standard initialization procedures are still run, so this is not a total @override
    super.initState();
    // https://www.flutterbeads.com/call-method-after-build-in-flutter/
    // the .addPostFrameCallback is called after the very last frame of the widget has been drawn during build()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cm = CommunicationManager(handleMessage);
    });
  }

  @override
  void dispose() {
    cm.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenShotController,
      child: GameTable(
        gameVariables,
        actionMethods,
        screenShotController,
      ),
    );
  }
}
