
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yield_mate/models/plot_model.dart';

class DatabaseService {

  final String uid;
  var plots = [];
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference plotCollection = FirebaseFirestore.instance.collection('plots');
  final CollectionReference regionCollection = FirebaseFirestore.instance.collection('regions');
  final CollectionReference seedCollection = FirebaseFirestore.instance.collection('seeds');

  // user functions
  Future updateUserData(String email, String username, String fName, String lName) async {
    await demoPlotData();
    return await userCollection.doc(uid).set({
      'email': email,
      'username': username,
      'First Name': fName,
      'Last Name': lName,
    });
  }

  // plot functions
  Future demoPlotData() async {
    return await plotCollection.doc('demo').set({
      'user': uid,
      'name': 'Demo Plot',
      'iconPath': 'assets/icons/plot_icon.png',
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
      'nutrients': [1, 2, 3],
    });
  }

  // create plot
  Future addPlot(String name, String crop, double size, String regionId, String seedId, int seedAmount, List<int> nutrients, int yieldAmount) async {
    return await plotCollection.add({
      'user': uid,
      'name': name,
      'iconPath': 'assets/icons/plot_icon.png',
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
        iconPath: doc['iconPath'] ?? '',
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

}