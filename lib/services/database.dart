import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String email, String username, String fName, String lName) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'username': username,
      'First Name': fName,
      'Last Name': lName,
    });
  }
}
