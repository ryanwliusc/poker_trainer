import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'evaluator.dart';

class StatsPage extends StatefulWidget {
  StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int _totalPlayed = 0;
  int _totalCorrect = 0;
  int _easyPlayed = 0;
  int _easyCorrect = 0;
  int _mediumPlayed = 0;
  int _mediumCorrect = 0;
  int _hardPlayed = 0;
  int _hardCorrect = 0;

  void fetchData() async {
    final userId = Supabase.instance.client.auth.currentSession?.user.id;

    if (userId != null) {
      final response = await Supabase.instance.client
          .from('Stats')
          .select()
          .eq('id', userId);

        final data = response;
        _easyCorrect = data[0]['correct1'];
        int easyIncorrect = data[0]['incorrect1'];
        _easyPlayed = _easyCorrect + easyIncorrect;
        _mediumCorrect = data[0]['correct2'];
        int mediumIncorrect = data[0]['incorrect2'];
        _mediumPlayed = _mediumCorrect + mediumIncorrect;
        _hardCorrect = data[0]['correct3'];
        int hardIncorrect = data[0]['incorrect3'];
        _hardPlayed = _hardCorrect + hardIncorrect;
        _totalCorrect = _easyCorrect + _mediumCorrect + _hardCorrect;
        _totalPlayed = _easyPlayed + _mediumPlayed + _hardPlayed;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    appBar: AppBar(
      centerTitle: true,
      title: Text('Stats'),
    );
    return Scaffold(
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
              Text('Overall hands played: ${_totalPlayed.toString()}'),
              SizedBox(height: 10),
              Text('Overall accuracy rate: ${(_totalCorrect/(max(_totalPlayed, 1))).toStringAsFixed(2)}'),
              SizedBox(height: 10),
              Text('Easy hands played: ${_easyPlayed.toString()}'),
              SizedBox(height: 10),
              Text('Easy accuracy rate: ${(_easyCorrect/(max(_easyPlayed, 1))).toStringAsFixed(2)}'),
              SizedBox(height: 10),
              Text('Medium hands played: ${_mediumPlayed.toString()}'),
              SizedBox(height: 10),
              Text('Medium accuracy rate: ${(_mediumCorrect/(max(_mediumPlayed, 1))).toStringAsFixed(2)}'),
              SizedBox(height: 10),
              Text('Hard hands played: ${_hardPlayed.toString()}'),
              SizedBox(height: 10),
              Text('Hard accuracy rate: ${(_hardCorrect/(max(_hardPlayed, 1))).toStringAsFixed(2)}'),
              SizedBox(height: 10),
              ElevatedButton(onPressed: fetchData, child: Text("Update Data")),
              ]

          ),
        )
        )

    );
  }
}