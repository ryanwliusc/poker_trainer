import 'package:flutter/material.dart';
import 'package:poker_trainer/user.dart' as u;
import 'package:poker_trainer/user_value_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _uvn = UserValueNotifier();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
      ),
      body: Container(
          margin: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextField(
                      onChanged: (value) {
                        _uvn.update(email: value);
                      },
                      decoration: InputDecoration(
                          labelText: 'Email'
                      )),
                  TextField(
                      onChanged: (value) {
                        _uvn.update(password: value);
                      },
                      decoration: InputDecoration(
                          labelText: 'Password'
                      )),
                  SizedBox(height: 20),
                  ValueListenableBuilder<u.User>(
                      valueListenable: _uvn,
                      builder: (context, user, _) {
                        return ElevatedButton(
                            onPressed: () async {
                              if (user.email != '' && user.password != '') {
                                try {
                                  final AuthResponse res = await Supabase
                                      .instance.client.auth.signInWithPassword(
                                    email: user.email,
                                    password: user.password,
                                  );
                                  final User? player = res.user;
                                  if (player != null) {
                                    Navigator.pushNamed(context, '/play');
                                  }
                                }
                                catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Invalid Credentials'),
                                    ),
                                  );
                                }
                              }else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Missing email or password.'),
                                  ),
                                );
                              }
                            },
                            child: Text('Login'),
                        );

                      }
                  ),
                  SizedBox(height: 10),
          ElevatedButton(
          onPressed: () async {
            Navigator.pushNamed(context, '/register');
          },
            child: Text('Create Account'),
          )

                ]),
          )
      ),
    );
  }
}