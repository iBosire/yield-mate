import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  String? username;
  String? fName;
  String? lName;
  String? email;
  String? type;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  // bool loggedIn;

  UserModel({
    required this.uid,
    this.username,
    this.fName,
    this.lName,
    this.email,
    this.type,
    this.createdAt,
    this.updatedAt,
    });


  // UserModel.fromJson(Map<String, dynamic> json) {
  //   name = json['name'];
  //   email = json['email'];
  //   password = json['password'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['name'] = name;
  //   data['email'] = email;
  //   data['password'] = password;
  //   return data;
  // }
}