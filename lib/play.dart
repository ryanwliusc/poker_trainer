import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'evaluator.dart';

class PlayPage extends StatefulWidget {
  PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final List<PlayingCard> deck = standardFiftyTwoCardDeck();
  final List<PlayingCard> communityCards = [];
  final List<PlayingCard> otherHand = [];
  final List<PlayingCard> playerHand = [];
  final List<PlayingCard> burntCards = [];
  int _currState = 0;
  String _equity = "%";
  String _guess = "";
  int _difficulty = 1;
  int _easyIncorrect = 0;
  int _easyCorrect = 0;
  int _mediumIncorrect = 0;
  int _mediumCorrect = 0;
  int _hardIncorrect = 0;
  int _hardCorrect = 0;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    ResetHand();
    fetchData();
  }

  void fetchData() async {
    final userId = Supabase.instance.client.auth.currentSession?.user.id;

    if (userId != null) {
      _userId = userId;
      final response = await Supabase.instance.client
          .from('Stats')
          .select()
          .eq('id', userId);

      final data = response;
      _easyCorrect = data[0]['correct1'];
      _easyIncorrect = data[0]['incorrect1'];
      _mediumCorrect = data[0]['correct2'];
      _mediumIncorrect = data[0]['incorrect2'];
      _hardCorrect = data[0]['correct3'];
      _hardIncorrect = data[0]['incorrect3'];
    }
  }


    void DealCards() {
    if (_currState == 0){
      otherHand.add(deck.elementAt(0));
      playerHand.add(deck.elementAt(1));
      otherHand.add(deck.elementAt(2));
      playerHand.add(deck.elementAt(3));
    }
    else if (_currState == 1) {
      burntCards.add(deck.elementAt(4));
      communityCards.add(deck.elementAt(5));
      communityCards.add(deck.elementAt(6));
      communityCards.add(deck.elementAt(7));
    }
    else if (_currState == 2) {
      burntCards.add(deck.elementAt(8));
      communityCards.add(deck.elementAt(9));
    }
    else if (_currState == 3) {
      burntCards.add(deck.elementAt(10));
      communityCards.add(deck.elementAt(11));
    }
    else {
      ResetHand();
    }
    setState(() {});
  }

  void ResetHand() {
    _equity = "%";
    deck.shuffle();
    communityCards.clear();
    otherHand.clear();
    playerHand.clear();
    burntCards.clear();
    _currState = 0;
    DealCards();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Play'),
      ),
      body: Container(
          margin: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: ElevatedButton(
                        onPressed: () {
                          _difficulty = 1;
                        },
                        child: Text('Easy Difficulty (+- 15%)'),
                      ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: ElevatedButton(
                        onPressed: () {
                          _difficulty = 2;
                        },
                        child: Text('Medium Difficulty (+- 10%)'),
                      ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                          child: ElevatedButton(
                        onPressed: () {
                          _difficulty = 3;
                        },
                        child: Text('Hard Difficulty (+- 5%)'),
                      ),
                      ),
                  ]
                  ),
                  SizedBox(height: 20),
                  Flexible(
                  child: Container(
                    height: 350,
                    width: 650,
                    decoration: BoxDecoration(
                    color: Colors.green[800],
                    borderRadius: const BorderRadius.all(Radius.elliptical(325, 200)),
                    ),
                    child: Column(
                      children: [
                        Flexible(
                          child: Container(
                          height: 100,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: otherHand.map((e) => PlayingCardView(card: e)).toList(),
                            ),
                          ),
                        ),
                        ),
                        SizedBox(height: 20),
                        Flexible(
                            child: Container(
                          height: 100,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: communityCards.map((e) => PlayingCardView(card: e)).toList(),
                            ),
                          ),
                        ),
                        ),
                        SizedBox(height: 20),
                        Flexible(
                            child: Container(
                          height: 100,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                              playerHand.map((e) => PlayingCardView(card: e)).toList(),
                            ),
                          ),
                        ),),
                      ],
                    ),
                  ),
                  ),
                  Text(_equity),
                  TextField(
                      onChanged: (value) {
                        _guess = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Enter a number between 0 and 100'
                      )),
                  ElevatedButton(
                    onPressed: () async {
                      if (double.tryParse(_guess) != null) {
                        double guess = double.parse(_guess);
                        if (_equity == '%' && guess >= 0 && guess <= 100) {
                          String correct = "";
                          double percentage = 0;
                          double exact = calculateProbability(playerHand, otherHand, communityCards) * 100;
                          if (_difficulty == 1){
                            percentage = 15.0;
                          }
                          else if (_difficulty == 2){
                            percentage = 10.0;
                          }
                          else {
                            percentage = 5.0;
                          }
                          bool accept = (guess >= exact - percentage) && (guess <= exact + percentage);
                          if (accept){
                            if (_difficulty == 1){
                              _easyCorrect += 1;
                              await Supabase.instance.client
                                  .from('Stats')
                                  .upsert({'correct1': _easyCorrect})
                                  .match({'id': _userId});
                            }
                            else if (_difficulty == 2){
                              _mediumCorrect += 1;
                              await Supabase.instance.client
                                  .from('Stats')
                                  .upsert({'correct2': _mediumCorrect})
                                  .match({'id': _userId});
                            }
                            else {
                              _hardCorrect += 1;
                              await Supabase.instance.client
                                  .from('Stats')
                                  .upsert({'correct3': _hardCorrect})
                                  .match({'id': _userId});
                            }
                            correct = "Correct";
                          }
                          else {
                            if (_difficulty == 1){
                              _easyIncorrect += 1;
                              await Supabase.instance.client
                                  .from('Stats')
                                  .upsert({'incorrect1': _easyIncorrect})
                                  .match({'id': _userId});
                            }
                            else if (_difficulty == 2){
                              _mediumIncorrect += 1;
                              await Supabase.instance.client
                                  .from('Stats')
                                  .upsert({'incorrect2': _mediumIncorrect})
                                  .match({'id': _userId});
                            }
                            else {
                              _hardIncorrect += 1;
                              await Supabase.instance.client
                                  .from('Stats')
                                  .upsert({'incorrect3': _hardIncorrect})
                                  .match({'id': _userId});
                            }
                            correct = "Incorrect";
                          }
                          setState(() {
                            _equity = correct + ', Exact Probability of Winning: ${exact.toStringAsFixed(2)}%';
                          });
                        }
                      }
                    },
                    child: Text('Guess Equity!'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _currState += 1;
                      _equity = "%";
                      DealCards();
                    },
                    child: Text('Next Action'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async
                    {
                      await Supabase.instance.client.auth.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('Logout'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async
                    {
                      Navigator.pushNamed(context, '/stats');
                    },
                    child: Text('View Stats'),
                  ),
          ])

      ),
    )

    );
  }
}