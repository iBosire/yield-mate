import 'package:cloud_firestore/cloud_firestore.dart';

class SeedModel {
  String id;
  String name;
  String manufacturer;
  String crop;
  String timeToMaturity;
  Timestamp dateCreated;
  Timestamp dateUpdated;


  SeedModel({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.crop,
    required this.timeToMaturity,
    required this.dateCreated,
    required this.dateUpdated,
  });
}