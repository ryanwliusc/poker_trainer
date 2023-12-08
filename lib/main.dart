import 'package:flutter/material.dart';
import 'package:poker_trainer/play.dart';
import 'package:poker_trainer/register.dart';
import 'package:poker_trainer/stats.dart';
import 'login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hlbrfnlcxpnffymlrgmg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhsYnJmbmxjeHBuZmZ5bWxyZ21nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE2NTg5MTksImV4cCI6MjAxNzIzNDkxOX0.ZHCcUwJwZCU22GQ_oazamJAPV9K0uxfc9opbK1rgNuk',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poker Trainer',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: LoginPage(),
      routes: <String, WidgetBuilder> {
        '/login' : (BuildContext context) => LoginPage(),
        '/register' : (BuildContext context) => RegisterPage(),
        '/play' : (BuildContext context) => PlayPage(),
        '/stats' : (BuildContext context) => StatsPage(),
      },
    );
  }
}

