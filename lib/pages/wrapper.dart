import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yield_mate/models/user_model.dart';
import 'package:yield_mate/pages/field.dart';
import 'package:yield_mate/pages/login.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if(user == null) {
      return const LoginPage();
    } else {
      return const FieldPage();
    }
  }
}