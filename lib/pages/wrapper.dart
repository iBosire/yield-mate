import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yield_mate/models/user_model.dart';
import 'package:yield_mate/pages/farmer/home.dart';
import 'package:yield_mate/pages/login.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if(user == null) {
      return LoginPage();
    } else {
      return FieldPage();
    }
  }
}