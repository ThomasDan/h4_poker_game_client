class PlayingCard {
  // the question-mark allows these strings to potentially be null. This is in the case of other players having concealed cards.
  String? suit;
  String? value;

  // Empty constructor for concealed cards (their suit and value are plain unknown to us, we just know they have a Card)
  PlayingCard();

  // Named Constructor
  PlayingCard cardNotNull(String suit, String value) {
    PlayingCard card = PlayingCard();
    card.suit = suit;
    card.value = value;
    return card;
  }

  // If it is a known card, this is its image
  // If it is an unknown card, this is its backside
  String imageFilePath() {
    return './assets/images/cards/${suit != null && value != null ? '${value}_of_$suit.png' : 'card_backside.png'}';
  }
}
