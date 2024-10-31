
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference plotCollection = FirebaseFirestore.instance.collection('plots');

  Future updateUserData(String email, String username, String fName, String lName) async {
    await demoPlotData();
    return await userCollection.doc(uid).set({
      'email': email,
      'username': username,
      'First Name': fName,
      'Last Name': lName,
    });
  }

  Future demoPlotData() async {
    return await plotCollection.doc('demo').set({
      'user': uid,
      'name': 'Demo Plot',
      'status': 0,
      'crop': 'Maize',
      'area': 1.0,
      'yield': 0.0,
      'dateCreated': DateTime.now(),
    });
  }

  Future getPlotsByUser() async {
    // QuerySnapshot response = await plotCollection.where('user', isEqualTo: uid).get();
    var plots = [];
    // for (var doc in response.docs) {
    //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //   plots.add(data);
    // }
    return plots;
  }
  // get plots stream
  Stream<QuerySnapshot> get plots{
    // filter plots by user
    return plotCollection.where("user", isEqualTo: uid).snapshots();
  }
}