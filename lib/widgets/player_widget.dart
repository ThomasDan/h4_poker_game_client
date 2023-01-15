import 'package:flutter/cupertino.dart';

import '../models/playing_card.dart';
import '../models/player.dart';

class PlayerWidget extends StatefulWidget {
  final Player player;

  PlayerWidget(this.player, {super.key});

  @override
  State<PlayerWidget> createState() => _PlayerWidget();
}

class _PlayerWidget extends State<PlayerWidget> {
  late Player player;

  @override
  void initState() {
    player = widget.player;

    super.initState();
  }

  void updatePlayer(Player _player) {
    setState(() {
      player = _player;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(player.name + '\n' + player.bananas.toString());
  }
}
