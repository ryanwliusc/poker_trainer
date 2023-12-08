import 'package:playing_cards/playing_cards.dart';
import 'package:poker/poker.dart';

String cardConverter(PlayingCard card) {
  Rank rank;
  Suits suit;

  switch (card.value) {
    case CardValue.two:
      rank = Rank.deuce;
      break;
    case CardValue.three:
      rank = Rank.trey;
      break;
    case CardValue.four:
      rank = Rank.four;
      break;
    case CardValue.five:
      rank = Rank.five;
      break;
    case CardValue.six:
      rank = Rank.six;
      break;
    case CardValue.seven:
      rank = Rank.seven;
      break;
    case CardValue.eight:
      rank = Rank.eight;
      break;
    case CardValue.nine:
      rank = Rank.nine;
      break;
    case CardValue.ten:
      rank = Rank.ten;
      break;
    case CardValue.jack:
      rank = Rank.jack;
      break;
    case CardValue.queen:
      rank = Rank.queen;
      break;
    case CardValue.king:
      rank = Rank.king;
      break;
    case CardValue.ace:
      rank = Rank.ace;
      break;
    default:
      throw ArgumentError('Invalid CardValue');
  }
  switch (card.suit) {
    case Suit.clubs:
      suit = Suits.club;
      break;
    case Suit.spades:
      suit = Suits.spade;
      break;
    case Suit.hearts:
      suit = Suits.heart;
      break;
    case Suit.diamonds:
      suit = Suits.diamond;
      break;
    default:
      throw ArgumentError('Invalid Suit');
  }

  return rank.toString()+suit.toString();
}


double calculateProbability(List<PlayingCard> playerHand, List<PlayingCard> otherHand, List<PlayingCard> communityCards) {
  String pHand = cardConverter(playerHand.elementAt(0)) + cardConverter(playerHand.elementAt(1));
  String oHand = cardConverter(otherHand.elementAt(0)) + cardConverter(otherHand.elementAt(1));
  ImmutableCardSet cardSet = ImmutableCardSet.empty();
  for (PlayingCard pc in communityCards) {
    cardSet = cardSet.added(Card.parse(cardConverter(pc)));
  }
  MontecarloEvaluator evaluator = MontecarloEvaluator(
    communityCards: cardSet,
    players: [
      HandRange.parse(pHand),
      HandRange.parse(oHand),
    ],
  );
  var wins = [0, 0];

  for (var matchup in evaluator.take(10000)) {
    for (var i in matchup.wonPlayerIndexes) {
    wins[i] += 1;
    }
  }
  return wins[0] / (wins[0] + wins[1]);
}