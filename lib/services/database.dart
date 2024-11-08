
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yield_mate/models/plot_model.dart';
import 'package:yield_mate/models/seed_model.dart';
import 'package:yield_mate/models/user_model.dart';

class DatabaseService {

  final String uid;
  var plots = [];
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference plotCollection = FirebaseFirestore.instance.collection('plots');
  final CollectionReference regionCollection = FirebaseFirestore.instance.collection('regions');
  final CollectionReference seedCollection = FirebaseFirestore.instance.collection('seeds');
  final CollectionReference cropCollection = FirebaseFirestore.instance.collection('crops');

  // user functions
  Future createNewUser(String email, String username, String fName, String lName) async {
    await demoPlotData();
    return await userCollection.doc(uid).set({
      'email': email,
      'username': username,
      'fName': fName,
      'lName': lName,
      'type': 'farmer',
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    });
  }
  // update user details
  Future updateUserDetails(String username, String fName, String lName) async {
    return await userCollection.doc(uid).update({
      'username': username,
      'fName': fName,
      'lName': lName,
      'updatedAt': DateTime.now(),
    });
  }
  // user stream
  Stream<List<UserModel>> get userStream{
    return userCollection.snapshots().map((QuerySnapshot snapshot) => _userListFromSnapshot(snapshot));
  }
  // convert user data from snapshot
  List<UserModel> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
        uid: doc.id,
        username: doc['username'] ?? '',
        fName: doc['fName'] ?? '',
        lName: doc['lName'] ?? '',
        email: doc['email'] ?? '',
        type: doc['type'] ?? '',
        createdAt: doc['createdAt'] ?? '',
        updatedAt: doc['updatedAt'] ?? '',
      );
    }).toList();
  }
  // get user data
  Future<UserModel> getUserData() async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    return UserModel(
      uid: doc.id,
      username: doc['username'] ?? '',
      fName: doc['fName'] ?? '',
      lName: doc['lName'] ?? '',
      email: doc['email'] ?? '',
      type: doc['type'] ?? '',
      createdAt: doc['createdAt'] ?? '',
      updatedAt: doc['updatedAt'] ?? '',
    );
  }
  // delete user
  Future deleteUser(String userId) async {
    return await userCollection.doc(userId).delete();
  }
  // get all users
  Future getUsers() async {
    QuerySnapshot response = await userCollection.where("type", isEqualTo: "farmer").get();
    List<UserModel> users = _userListFromSnapshot(response);
    log("Response from the DB: ${users.length} users");
    return users;
  }


  // PLOT FUNCTIONS
  Future demoPlotData() async {
    return await plotCollection.doc('demo').set({
      'user': uid,
      'name': 'Demo Plot',
      'size': 1.0,
      'status': 0,
      'crop': 'Maize',
      'score': 0,
      'regionId': 'demo',
      'seedId': 'demo',
      'seedAmount': 50,
      'active': true,
      'yieldAmount': 1,
      'dateCreated': DateTime.now(),
      'dateUpdated': DateTime.now(),
      'nutrients': [1, 2, 3],
    });
  }
  // create plot
  Future addPlot(String name, String crop, double size, String regionId, String seedId, int seedAmount, List<int> nutrients, int yieldAmount) async {
    return await plotCollection.add({
      'user': uid,
      'name': name,
      'size': size,
      'status': 0,
      'crop': crop,
      'score': 0,
      'regionId': regionId,
      'seedId': seedId,
      'seedAmount': seedAmount,
      'active': true,
      'yieldAmount': yieldAmount,
      'dateCreated': DateTime.now(),
      'dateUpdated': DateTime.now(),
      'nutrients': nutrients,
    });
  }
  // update plot
  Future updatePlotDetails(String plotId, String name, List<int> nutrients) async {
    return await plotCollection.doc(plotId).update({
      'name': name,
      'nutrients': nutrients,
      'dateUpdated': DateTime.now(),
    });
  }
  Future updatePlotStatus(String plotId, int status, int yieldAmount) async {
    return await plotCollection.doc(plotId).update({
      'status': status,
      'yieldAmount': yieldAmount,
      'dateUpdated': DateTime.now(),
    });
  }
  // delete plot
  Future deletePlot(String plotId) async {
    return await plotCollection.doc(plotId).delete();
  }
  // get plots by user
  Future getPlotsByUser() async {
    QuerySnapshot response = await plotCollection.where('user', isEqualTo: uid).get();
    List<PlotModel> plots = _plotListFromSnapshot(response);
    log("Response from the DB: ${plots.length} plots");
    return plots;
  }
  // plot list from snapshot
  List<PlotModel> _plotListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PlotModel(
        plotId: doc.id,
        name: doc['name'] ?? '',
        userId: doc['user'] ?? '',
        size: doc['size'] ?? 0,
        status: doc['status'] ?? 0,
        crop: doc['crop'] ?? '',
        score: doc['score'] ?? '',
        regionId: doc['regionId'] ?? '',
        seedId: doc['seedId'] ?? '',
        seedAmount: doc['seedAmount'] ?? 0,
        active: doc['active'] ?? false,
        dateCreated: doc['dateCreated'] ?? '',
        nutrients: doc['nutrients'] ?? [],
        dateUpdated: doc['dateUpdated'] ?? '',
      );
    }).toList();
  }
  // get plots stream
  Stream<List<PlotModel>> get plotStream{
    // filter plots by user
    // .map((QuerySnapshot snapshot) => _plotListFromSnapshot(snapshot))
    return plotCollection.where("user", isEqualTo: uid).snapshots().map((QuerySnapshot snapshot) => _plotListFromSnapshot(snapshot));
  }

  // region functions

  // seed functions
  // add seed
  Future addSeed(String name, String manufacturer, String crop, String timeToMaturity) async {
    return await seedCollection.add({
      'name': name,
      'manufacturer': manufacturer,
      'crop': crop,
      'timeToMaturity': timeToMaturity,
      'dateCreated': DateTime.now(),
      'dateUpdated': DateTime.now(),
    });
  }

  // seed stream
  Stream<List<SeedModel>> get seedStream{
    return seedCollection.snapshots().map((QuerySnapshot snapshot) => _seedListFromSnapshot(snapshot));
  }
  List<SeedModel> _seedListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SeedModel(
        id: doc.id,
        name: doc['name'] ?? '',
        manufacturer: doc['manufacturer'] ?? '',
        crop: doc['crop'] ?? '',
        timeToMaturity: doc['timeToMaturity'] ?? '',
        dateCreated: doc['dateCreated'] ?? '',
        dateUpdated: doc['dateUpdated'] ?? '',
      );
    }).toList();
  }
}