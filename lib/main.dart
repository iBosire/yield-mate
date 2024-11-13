import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yield_mate/models/user_model.dart';
import 'package:yield_mate/pages/details.dart';
import 'package:yield_mate/pages/home.dart';
import 'package:yield_mate/pages/wrapper.dart';
import 'package:yield_mate/services/auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Yield Mate',
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/modeltab': (context) => HomePage(defIndex: 1,),
          '/plot': (context) => DetailsPage(type: 'viewplot',),
          '/addplot': (context) => DetailsPage(type: 'newplot',),
          '/editplot': (context) => DetailsPage(type: 'editplot',),
          '/user': (context) => DetailsPage(type: 'viewuser',),
          '/edituser': (context) => DetailsPage(type: 'edituser',),
          '/location': (context) => DetailsPage(type: 'viewlocation',),
          '/addlocation': (context) => DetailsPage(type: 'newlocation',),
          '/editlocation': (context) => DetailsPage(type: 'editlocation',),
          '/seed': (context) => DetailsPage(type: 'viewseed',),
          '/addseed': (context) => DetailsPage(type: 'newseed',),
          '/editseed': (context) => DetailsPage(type: 'editseed',),
          '/model': (context) => DetailsPage(type: 'viewmodel',),
          '/addmodel': (context) => DetailsPage(type: 'newmodel',),
          '/editmodel': (context) => DetailsPage(type: 'editmodel',),
          '/crop': (context) => DetailsPage(type: 'viewcrop',),
          '/addcrop': (context) => DetailsPage(type: "newcrop",),
          '/editcrop': (context) => DetailsPage(type: "editcrop",)
        },
      ),
    );
  }
}

