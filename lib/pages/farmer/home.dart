import 'dart:developer';

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

class FieldPageState extends State<FieldPage> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  List<PlotModel?> plots = [];
  int _selectedTabIndex = 0;
  String currentUser = "";
  int currentTabIndex = 0;

  Future<List<PlotModel?>?> _getPlots(String uid) async {
    log("UID passed to _getPlots: $uid");
    List<PlotModel?> p = await DatabaseService(uid: uid).getPlotsByUser();
    return p;
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
      _getPlots(currentUser);
    });
  }

  @override
  void initState() {
    super.initState();
    _auth.user.first.then((_) {
      _auth.user.listen((user) {
        setState(() {
          currentUser = user?.uid ?? 'No user';
          log("Current User: $currentUser");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    List<Widget> navPages = <Widget>[
      ListView(
        children: [
          // AllPlotsSection(plots: plots.cast<PlotModel>()),
          FutureBuilder<List<PlotModel?>?>(
            future: _getPlots(currentUser), 
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if(snapshot.hasError) {
                log("Error: ${snapshot.error}");
                return const Center(
                  child: Text('Error loading plots'),
                );
              } else if(snapshot.hasData) {
                log("Data: ${snapshot.data}");
                plots = snapshot.data!;
                if(plots.isNotEmpty) {
                  return AllPlotsSection(plots: snapshot.data!.cast<PlotModel>());
                } else {
                  return const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: AddNew(name: 'Plots'),
                      ),
                    ],
                  );
                }
              } else {
                return const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: AddNew(name: 'Plots'),
                    ),
                  ],
                );
              }
            }
          ),
          const SizedBox(height: 20),
        ],
      ),
      ListView(
        children: [
          AllPlotsSection(plots: plots.where((plot) => plot?.active == true).toList().cast<PlotModel>()),
        ],
      ),
      ListView(
        children: [
          AllPlotsSection(plots: plots.where((plot) => plot?.active == false).toList().cast<PlotModel>()),
        ]
      )
    ];

    return StreamProvider<List<PlotModel?>?>.value(
      initialData: null,
      value: DatabaseService(uid: currentUser).plotStream,
      child: DefaultTabController(
        length: 2,
        child: Builder(
          builder: (BuildContext context) {
            final TabController tabController = DefaultTabController.of(context);
            tabController.addListener(() {
              if (!tabController.indexIsChanging) {
                setState(() {
                  currentTabIndex = tabController.index;
                });
              }
            });
            return Scaffold(
              appBar: appBar('View'),
              backgroundColor: Colors.white,
              body: TabBarView(
                children: [
                  Center(
                    child: navPages[_selectedTabIndex],
                  ),
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                ]
              ),
              bottomNavigationBar: tabController.index == 1? null : plotsBottomNavbar(0),
            );
          }
        ),
      )
    );
  }

  BottomNavigationBar? plotsBottomNavbar(int index) {
    log("Index: $index");
    if(index == 0) {
      return BottomNavigationBar(
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
        );
    } else {
      return null;
    }
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
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('YieldMate'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                );
              }
            );
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.logout, color: Colors.grey,),
          )
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              _showSettings(context, _auth);
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
        bottom: const TabBar(
          tabs: [
            Tab(
              child: Text('Plots', style: TextStyle(color: Colors.black),),
            ),
            Tab(
              child: Text('Reports', style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
    );
  }
}

void _showSettings(BuildContext context, AuthService _auth) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    await _auth.signOut();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }
      );
    }

class AddNew extends StatelessWidget {
  const AddNew({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    if(name == 'none') {
      return Container();
    }
    return GestureDetector(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 30,),
            const Icon(Icons.add, size: 40,),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add $name',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'add new ${name.toLowerCase()}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        if (name == 'Plots') {
          Navigator.pushNamed(context, '/addplot');
        }
      },
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
    if(plots.isEmpty) {
      return const Center(
        child: Text('No plots found'),
      );
    }
    return SingleChildScrollView(
      child: Column(
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
          // Add Button
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: AddNew(name: 'Plots'),
          ),
          const SizedBox(height: 20),
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
                  border: plots[index].active? Border.all(color: Colors.amber, width: 2) : Border.all(color: Colors.green, width: 2),
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
                    const Icon(Icons.grass, size: 50,),
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
                          '${plots[index].size} Acres | ${plots[index].crop} | Score: ${plots[index].score}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: 37,
                      height: 37,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/plot', arguments: plots[index]);
                        },
                        child: const Icon(Icons.arrow_forward_ios_rounded, size: 30, color: Colors.white,),
                        ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
