import 'package:cloud_firestore/cloud_firestore.dart';

class CropModel {
  String id;
  String name;
  String marketPrice;
  Timestamp dateCreated;
  Timestamp dateUpdated;

  CropModel({
    required this.id,
    required this.name,
    required this.marketPrice,
    required this.dateCreated,
    required this.dateUpdated,
  });
}