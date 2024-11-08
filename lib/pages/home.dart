// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:provider/provider.dart';
import 'package:yield_mate/models/plot_model.dart';
import 'package:yield_mate/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yield_mate/pages/wrapper.dart';
import 'package:yield_mate/services/auth.dart';
import 'package:yield_mate/services/database.dart';

import '../models/category_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  List<CategoryModel> categories = [];
  List<PlotModel> plots = [];
  List<UserModel> users = [];
  String currentUser = "";

  void _getCategories() {
    categories = CategoryModel.getCategories();
  }

  // void _getUsers() async {
  //   users = UserModel.getUsers();
  // }

  void _initialData() {
    _getCategories();
    // _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    _initialData();
    _auth.user.listen((user) {
      currentUser = user?.uid ?? 'No user';
    }); // Ensure this is awaited if necessary
    return DefaultTabController(
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
                UsersSection(users: users, uid: currentUser),
                SizedBox(height: 40),
              ],
            ),
            ListView(
              children: [
                MySearchBar(),
                SizedBox(height: 40),
                // CATEGORIES
                CategoriesSection(categories: categories),
                SizedBox(height: 40),
                // PLOTS
                PlotsSection(plots: plots),
                SizedBox(height: 40),
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
            await _auth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xffF7F8F8),
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

class UsersSection extends StatelessWidget {
  const UsersSection({
    super.key,
    required this.users,
    required this.uid,
  });

  final List<dynamic> users;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserModel?>?>.value(
      initialData: null,
      value: DatabaseService(uid: uid).userStream,
      child: FutureBuilder(
        future: DatabaseService(uid: uid).userStream.first,
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

class PlotsSection extends StatelessWidget {
  const PlotsSection({
    super.key,
    required this.plots,
  });

  final List<PlotModel> plots;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Results',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 15),
        // LIST OF PLOTS
        SizedBox(
          height: 240,
          child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                width: 210,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset('yield_mate/assets/icons/plot_icon.svg', height: 50, width: 50),
                    Column(
                      children: [
                        Text(
                          plots[index].name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${plots[index].size} | ${plots[index].status} | ${plots[index].score}%',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    // VIEW BUTtON
                    Container(
                      height: 45,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          colors: [
                            plots[index].active ? Color.fromARGB(255, 39, 167, 156) : Colors.transparent,
                            plots[index].active ? Color.fromARGB(255, 43, 124, 64) : Colors.transparent,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'View',
                          style: TextStyle(
                            color: plots[index].active ? Colors.white : Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                      ),
                  ],
                ),
              );
            },
            itemCount: plots.length,
            separatorBuilder: (context, index) => SizedBox(width: 20),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20, right: 20),
          ),
        )
      ],
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
    required this.categories,
  });

  final List<CategoryModel> categories;

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
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: categories[index].boxColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
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
              );
            },
          ),
        )
      ],
    );
  }
}

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
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