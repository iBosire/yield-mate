import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yield_mate/models/user_model.dart';
import 'package:yield_mate/pages/details/details.dart';
import 'package:yield_mate/pages/admin/home.dart';
import 'package:yield_mate/pages/wrapper.dart';
import 'package:yield_mate/services/auth.dart';
import 'package:yield_mate/shared/info.dart';

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
          '/modeltab': (context) => const HomePage(defIndex: 1,),
          '/plot': (context) => const DetailsPage(type: 'viewplot',),
          '/addplot': (context) => const DetailsPage(type: 'newplot',),
          '/editplot': (context) => const DetailsPage(type: 'editplot',),
          '/user': (context) => const DetailsPage(type: 'viewuser',),
          '/edituser': (context) => const DetailsPage(type: 'edituser',),
          '/location': (context) => const DetailsPage(type: 'viewlocation',),
          '/addlocation': (context) => const DetailsPage(type: 'newlocation',),
          '/editlocation': (context) => DetailsPage(type: 'editlocation',),
          '/seed': (context) => const DetailsPage(type: 'viewseed',),
          '/addseed': (context) => const DetailsPage(type: 'newseed',),
          '/editseed': (context) => const DetailsPage(type: 'editseed',),
          '/model': (context) => const DetailsPage(type: 'viewmodel',),
          '/addmodel': (context) => const DetailsPage(type: 'newmodel',),
          '/editmodel': (context) => const DetailsPage(type: 'editmodel',),
          '/crop': (context) => const DetailsPage(type: 'viewcrop',),
          '/addcrop': (context) => const DetailsPage(type: "newcrop",),
          '/editcrop': (context) => const DetailsPage(type: "editcrop",),
          '/farmerinfo': (context) => const InfoPage(type: "farmer",),
          '/admininfo': (context) => const InfoPage(type: "admin",),
        },
      ),
    );
  }
}

