// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:provider/provider.dart';
import 'package:yield_mate/models/ml_model.dart';
import 'package:yield_mate/models/plot_model.dart';
import 'package:yield_mate/models/seed_model.dart';
import 'package:yield_mate/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yield_mate/pages/wrapper.dart';
import 'package:yield_mate/services/auth.dart';
import 'package:yield_mate/services/database.dart';

import '../models/category_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.defIndex});
  final int defIndex;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  // TODO: make this private
  late DatabaseService db;
  List<PlotModel> plots = [];
  List<UserModel> users = [];
  String currentUser = "";

  // void _getUsers() async {
  //   users = UserModel.getUsers();
  // }

  void _initialData() {
    // _getCategories();
    // _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    _initialData();
    _auth.user.listen((user) {
      currentUser = user?.uid ?? 'No user';
    });
    db = DatabaseService(uid: currentUser); // Ensure this is awaited if necessary
    return DefaultTabController(
      initialIndex: widget.defIndex,
      length: 2,
      child: Scaffold(
        // NAVIGATION BAR
        appBar: appBar(),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            ListView(
              children: [
                // USERS
                UsersSection(users: users,db: db),
                SizedBox(height: 40),
              ],
            ),
            ListView(
              children: [
                SizedBox(height: 40),
                // CATEGORIES
                CategoriesWidget(db: db,),
              ]
            ),
          ],
        ),
      )
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
          'Manage',
          style: TextStyle(
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
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
                      },
                      child: Text('Logout'),
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
              color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.logout, color: Colors.grey,),
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
                color: Color(0xffF7F8F8),
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
        bottom: TabBar(
          tabs: [
            Tab(
              child: Text(
                'Users',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Model',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
    );

  }
}

//* Users Section
class UsersSection extends StatelessWidget {
  const UsersSection({
    super.key,
    required this.users,
    required this.db,
  });

  final List<dynamic> users;
  final DatabaseService db;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserModel?>?>.value(
      initialData: null,
      value: db.userStream,
      child: FutureBuilder(
        future: db.userStream.first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return allUsers(snapshot.data!);
          } else {
            return Center(child: Text('No data'));
          }
        }
      ),
    );
  }

  Column allUsers(List<UserModel> user) {
    final users = user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text(
            'Users',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 15),
        ListView.separated(
          itemCount: users.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 20),
          padding: EdgeInsets.only(left: 20, right: 20),
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff1D1617).withOpacity(0.11),
                    offset: Offset(0, 10),
                    blurRadius: 40,
                    spreadRadius: 0,
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.person_outline, size: 40,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${users[index].fName ?? ''} ${users[index].lName ?? ''}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${users[index].type} | 5 Projects ',
                        style: TextStyle(
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
                      color: Color(0xffF7F8F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/user', arguments: users[index]);
                      },
                      child: SvgPicture.asset('assets/icons/right-arrow.svg',)
                      ),
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

//* Categories Widget
class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({
    super.key,
    required this.db,
  });
  final DatabaseService db;

  @override
  State<CategoriesWidget> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesWidget> {
  List<CategoryModel> categories = [];  

  void _getCategories() {
    categories = CategoryModel.getCategories();
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  String? currentCategory;

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Category',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // LIST OF CATEGORIES
        SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20, right: 20),
            itemCount: categories.length,
            separatorBuilder: (context, index) => SizedBox(width: 25),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    categories[index].isSelected = true;
                    if (categories[index].isSelected) {
                      currentCategory = categories[index].name;
                    }
                    for (var element in categories) {
                      if (element != categories[index]) {
                        element.isSelected = false;
                      }
                    }
                    log("Current Category: $currentCategory");
                  });
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: categories[index].boxColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                    border: categories[index].isSelected ? categories[index].border2 : categories[index].border1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(categories[index].iconPath,),
                        ),
                      ),
                      Text(
                        categories[index].name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: AddNew(name: currentCategory ?? 'none'),
        ),
        SizedBox(height: 20),
        // RESULTS
        resultsSection(currentCategory, widget.db),
      ],
    );
  }
}

//* Process results from the selected category
Widget resultsSection(String? index, DatabaseService db){
  if (index == "Seeds") {
    log("Seeds Selected");
    return StreamProvider<List<SeedModel?>?>.value(
      initialData: null,
      value: db.seedStream,
      child: FutureBuilder(
        future: db.seedStream.first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SeedsSection(context, seeds: snapshot.data!);
          } else {
            return Center(child: Text('No data'));
          }
        }
      ),
    );
  } else if (index == "Model") {
    return StreamProvider<List<MlModel?>?>.value(
      initialData: null,
      value: db.modelStream,
      child: FutureBuilder(
        future: db.modelStream.first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: ModelsSection(context, models: snapshot.data!),
            );
          } else {
            return Center(child: Text('No data'));
          }
        }
      ),
    );
  } else if (index == "Locations") {
    return StreamProvider<List<PlotModel?>?>.value(
      initialData: null,
      value: db.plotStream,
      child: FutureBuilder(
        future: db.plotStream.first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: Text('Location Information'),
            );
          } else {
            return Center(child: Text('No data'));
          }
        }
      ),
    );
  } else {
    return Container(
      alignment: Alignment.center,
      child: Text('Select a Category to Display Information'),
    );
  }
}

//* Displays Seeds Section 
Widget SeedsSection(BuildContext context, {required List<SeedModel> seeds}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Text(
          'Seeds',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: 15),
      MySearchBar(),
      SizedBox(height: 15),
      ListView.separated(
        itemCount: seeds.length,
        controller: ScrollController(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => SizedBox(height: 20),
        padding: EdgeInsets.only(left: 20, right: 20),
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff1D1617).withOpacity(0.11),
                  offset: Offset(0, 10),
                  blurRadius: 40,
                  spreadRadius: 0,
                )
              ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.grass_sharp, size: 40,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${seeds[index].manufacturer}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${seeds[index].name} | ${seeds[index].crop}',
                      style: TextStyle(
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
                    color: Color(0xffF7F8F8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/seed', arguments: seeds[index]);
                    },
                    child: Icon(Icons.arrow_forward_ios, color: Colors.black,)
                    ),
                ),
              ],
            ),
          );
        },
      ),
      SizedBox(height: 20),
    ],
  );
}

//* Displays Models Section
Widget ModelsSection(BuildContext context, {required List<MlModel> models}){
  log("found ${models.length} models");
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Text(
          'Models',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: 15),
      MySearchBar(),
      SizedBox(height: 15),
      ListView.separated(
        itemCount: models.length,
        controller: ScrollController(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => SizedBox(height: 20),
        padding: EdgeInsets.only(left: 20, right: 20),
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff1D1617).withOpacity(0.11),
                  offset: Offset(0, 10),
                  blurRadius: 40,
                  spreadRadius: 0,
                )
              ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.smart_button, size: 40,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      models[index].name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      models[index].description,
                      style: TextStyle(
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
                    color: Color(0xffF7F8F8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/model', arguments: models[index]);
                    },
                    child: Icon(Icons.arrow_forward_ios, color: Colors.black,)
                    ),
                ),
              ],
            ),
          );
        },
      ),
      SizedBox(height: 20),
    ],
  );
}

//* Add Button
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
              color: Color(0xff1D1617).withOpacity(0.11),
              offset: Offset(0, 10),
              blurRadius: 40,
              spreadRadius: 0,
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 30,),
            Icon(Icons.add, size: 40,),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add $name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'add new ${name.toLowerCase()}',
                  style: TextStyle(
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
        if (name == 'Seeds') {
          Navigator.pushNamed(context, '/addseed');
        } else if (name == 'Model') {
          Navigator.pushNamed(context, '/addmodel');
        } else if (name == 'Locations') {
          Navigator.pushNamed(context, '/addlocation');
        }
      },
    );
  }
}
//* Search Bar
class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0,
          )
        ]
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(15),
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Color(0xffA0A3BD),
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset('assets/icons/search.svg'),
          ),
          suffixIcon: SizedBox(
            width: 100,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 0.1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/filter.svg'),
                  ),
                ],
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}