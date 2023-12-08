import 'package:flutter/material.dart';
import 'package:poker_trainer/user.dart' as u;
import 'package:poker_trainer/user_value_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _uvn = UserValueNotifier();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register'),
      ),
      body: Container(
          margin: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
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
                                    .instance.client.auth.signUp(
                                  email: user.email,
                                  password: user.password,
                                );
                                final User? player = res.user;
                                if (player != null) {
                                  await Supabase.instance.client.from('Stats').upsert({'id': player.id});
                                }
                              }
                              catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error ${e.toString()}'),
                                  ),
                                );
                              }
                            }else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Missing email, name, or password.'),
                                ),
                              );
                            }
                          },
                          child: Text('Register'),
                        );
                      }
                  )

                ]),
            ),
          )
      ),
    );
  }
}