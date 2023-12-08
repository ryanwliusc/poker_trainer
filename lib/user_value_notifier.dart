import 'package:flutter/cupertino.dart';
import 'user.dart';

class UserValueNotifier extends ValueNotifier<User>{

  UserValueNotifier() : super(User(email: '', password: ''));

  void update({String? email, String? name, String? password}) {
    User user = User(email: value.email, password: value.password);
    if (email != null){
      user.email = email;
    }
    if (password != null){
      user.password = password;
    }
    value = user;
  }
}
