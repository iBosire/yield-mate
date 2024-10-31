import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yield_mate/models/plot_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yield_mate/pages/farmer/plot_list.dart';
import 'package:yield_mate/pages/wrapper.dart';
import 'package:yield_mate/services/auth.dart';
import 'package:yield_mate/services/database.dart';
import 'package:provider/provider.dart';


class FieldPage extends StatefulWidget {
  const FieldPage({super.key});

  @override
  State<FieldPage> createState() => FieldPageState();
}

class FieldPageState extends State<FieldPage> {
  final AuthService _auth = AuthService();
  List<dynamic> plots = [];
  int _selectedTabIndex = 0;
  String currentUser = "";

  Future<void> _getPlots(String uid) async {
    plots = await DatabaseService(uid: uid).getPlotsByUser();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
      _getPlots(currentUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    _auth.user.listen((user) {
      currentUser = user?.uid ?? 'No user';
      log("Current User: $currentUser");
    }); // Ensure this is awaited if necessary

    List<Widget> navPages = <Widget>[
      ListView(
        children: [
          AllPlotsSection(plots: plots.cast<PlotModel>()),
        ],
      ),
      ListView(
        children: [
          AllPlotsSection(plots: plots.where((plot) => plot.status == 0).toList().cast<PlotModel>()),
        ],
      ),
      ListView(
        children: [
          AllPlotsSection(plots: plots.where((plot) => plot.status == 1).toList().cast<PlotModel>()),
        ]
      )
    ];

    return StreamProvider<QuerySnapshot<Object?>?>.value(
      initialData: null,
      value: DatabaseService(uid: currentUser).plots,
      child: Scaffold(
        appBar: appBar('Field Page'),
        backgroundColor: Colors.white,
        body: Center(
            child: PlotList(),
          ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'All Plots',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow_rounded),
              label: 'Ongoing',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stop_circle_rounded),
              label: 'Completed',
            ),
          ],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          currentIndex: _selectedTabIndex,
          onTap: onItemTapped,
        ),
      )
    );
  }

  AppBar appBar(String screenTitle) {
    return AppBar(
      title: Text(
          screenTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () async {
            await _auth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Wrapper()));
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              'assets/icons/back.svg',
              height: 20,
              width: 20,
            )
          )
        ),
        actions: [
          GestureDetector(
            onTap: () {

            },
            child: Container(
              margin: const EdgeInsets.all(10),
              width: 37,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xffF7F8F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/icons/settings.svg',
                height: 20,
                width: 20,
              )
            ),
          )
        ],
    );
  }
}

class AllPlotsSection extends StatelessWidget {
  const AllPlotsSection({
    super.key,
    required this.plots,
  });

  final List<PlotModel> plots;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            'Plots',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        ListView.separated(
          itemCount: plots.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          padding: const EdgeInsets.only(left: 20, right: 20),
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff1D1617).withOpacity(0.11),
                    offset: const Offset(0, 10),
                    blurRadius: 40,
                    spreadRadius: 0,
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(plots[index].iconPath, height: 50, width: 50),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plots[index].name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${plots[index].size} | Score: ${plots[index].score} | Crop: ${plots[index].crop}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      
                    },
                    child: SvgPicture.asset('assets/icons/right-arrow.svg',)
                    ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
