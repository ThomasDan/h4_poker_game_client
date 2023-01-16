import 'package:flutter/cupertino.dart';
import 'package:h4_poker_game_client/models/playing_card.dart';

class PlayingCardWidget extends StatelessWidget {
  final PlayingCard card;

  const PlayingCardWidget(this.card, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(
          // The card images have proportions of 1,452 height to 1 width
          height: 58.08,
          width: 40,
        ),
        child: Image.asset(card.imageFilePath()),
      ),
    );
  }
}
