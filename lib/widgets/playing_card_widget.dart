import 'package:flutter/cupertino.dart';
import 'package:h4_poker_game_client/models/playing_card.dart';

class PlayingCardWidget extends StatelessWidget {
  final PlayingCard card;
  final bool cardBig;

  const PlayingCardWidget(this.card, this.cardBig, {super.key});

  @override
  Widget build(BuildContext context) {
    double _height = cardBig ? 58.08 : 43.56;
    double _width = cardBig ? 40 : 30;
    return Container(
      padding: const EdgeInsets.all(1),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(
          // The card images have proportions of 1,452 height to 1 width
          height: _height,
          width: _width,
        ),
        child: Image.asset(card.imageFilePath()),
      ),
    );
  }
}
