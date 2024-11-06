import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  String id;
  String name;
  String temperture;
  int rainfall;
  String humidity;
  Timestamp dateCreated;
  Timestamp dateUpdated;

  LocationModel({
    required this.id,
    required this.name,
    required this.temperture,
    required this.rainfall,
    required this.humidity,
    required this.dateCreated,
    required this.dateUpdated,
  });
}