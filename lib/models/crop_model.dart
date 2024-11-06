import 'package:cloud_firestore/cloud_firestore.dart';

class CropModel {
  String id;
  String name;
  String description;
  Timestamp dateCreated;
  Timestamp dateUpdated;

  CropModel({
    required this.id,
    required this.name,
    required this.description,
    required this.dateCreated,
    required this.dateUpdated,
  });
}