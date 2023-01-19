import 'package:flutter/cupertino.dart';
import 'package:h4_poker_game_client/widgets/playing_card_widget.dart';

import '../models/player.dart';

class PlayerSeatWidget extends StatefulWidget {
  final Player player;
  final bool placeCardsBelow;

  const PlayerSeatWidget(this.player, this.placeCardsBelow, {super.key});

  @override
  State<PlayerSeatWidget> createState() => _PlayerSeatWidget();
}

class _PlayerSeatWidget extends State<PlayerSeatWidget> {
  late Player player;
  late bool placeCardsBelow;

  Widget fillSeat() {
    return player.name == null ? const Text('Seat Open') : playerSeated();
  }

  Widget playerSeated() {
    List<Widget> cards = [];
    for (int i = 0; i < player.hand.length; i++) {
      cards.add(PlayingCardWidget(player.hand[i], false));
    }
    if (placeCardsBelow) {
      return Column(
        children: [
          Text(
            '${player.name}\n${player.bananas.toString()}🍌',
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          Row(children: cards),
        ],
      );
    } else {
      return Row(
        children: [
          Text(
            '${player.name}\n${player.bananas.toString()}🍌',
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          Row(children: cards),
        ],
      );
    }
  }

  @override
  void initState() {
    player = widget.player;
    placeCardsBelow = widget.placeCardsBelow;

    super.initState();
  }

  void updatePlayer(Player _player) {
    setState(() {
      player = _player;
    });
  }

  @override
  Widget build(BuildContext context) {
    return fillSeat();
  }
}
