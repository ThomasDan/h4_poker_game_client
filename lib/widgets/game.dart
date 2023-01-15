import 'package:flutter/cupertino.dart';

import 'package:h4_poker_game_client/models/player.dart';
import 'package:h4_poker_game_client/widgets/communication_manager.dart';

class Game extends StatefulWidget {
  Player? player;

  Game(String name, {super.key}) {
    player = Player(name);
  }

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late CommunicationManager cm;

  @override
  // initState() is the very first thing that is run.
  void initState() {
    // super.initState() ensures that the standard initialization procedures are still run, so this is not a total @override
    super.initState();
    // https://www.flutterbeads.com/call-method-after-build-in-flutter/
    // the .addPostFrameCallback is called after the very last frame of the app has been drawn during build()
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Table(),
      ],
    );
  }
}
