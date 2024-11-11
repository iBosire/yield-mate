import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yield_mate/models/user_model.dart';
import 'package:yield_mate/pages/farmer/home.dart';
import 'package:yield_mate/pages/home.dart';
import 'package:yield_mate/pages/login.dart';
import 'package:yield_mate/services/database.dart';
import 'package:yield_mate/shared/loading.dart';


class Wrapper extends StatelessWidget {
  Wrapper({super.key});
  
  Future<UserModel?> getUserData(UserModel? user) async {
    if(user == null) {
      return null;
    }
    dynamic dUser = await DatabaseService(uid: user.uid).getUserData();
    log("User: $dUser");
    if(dUser == null) {
      return null;
    } else {
      return dUser;
    }
  }

  Widget getHomePage(UserModel user) {
    if(user.type == "farmer") {
      return FieldPage();
    } else if(user.type == "admin") {
      log("admin found");
      return HomePage(defIndex: 0,);
    } else {
      return LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context); 
    return FutureBuilder<UserModel?>(
      future: getUserData(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else if (snapshot.hasError) {
          log("Error: ${snapshot.error}");
          return LoginPage();
        } else if (snapshot.hasData) {
          return getHomePage(snapshot.data!);
        } else {
          return LoginPage();
        }
      },
    );
  }
}
