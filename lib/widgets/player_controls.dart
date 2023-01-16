import 'package:flutter/cupertino.dart';
import 'package:h4_poker_game_client/widgets/player_seat_widget.dart';

import '../models/player.dart';

class PlayerControls extends StatelessWidget {
  Player player;

  PlayerControls(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PlayerSeatWidget(player, true),
        Draggable<int>(
          data: 0,
          feedback: ConstrainedBox(
            constraints: const BoxConstraints.expand(
              height: 35,
              width: 35,
            ),
            child: Image.asset('./assets/images/bananaBunch.png'),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(
              height: 100,
              width: 100,
            ),
            child: Image.asset('./assets/images/bananaBunch.png'),
          ),
        )
      ],
    );
  }
}
