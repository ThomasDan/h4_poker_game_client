import 'package:flutter/cupertino.dart';
import 'package:h4_poker_game_client/models/player.dart';
import 'package:h4_poker_game_client/services/web_socket_service.dart';

class Game extends StatefulWidget {
  Player? player;
  Game(String name) {
    this.player = Player(name);
  }

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [WebSocketService()]),
    );
  }
}
