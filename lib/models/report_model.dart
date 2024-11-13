import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String id;
  String userId;
  String plotId;
  String projectedRevenue;
  String projectedYield;
  Timestamp dateCreated;
  Timestamp dateUpdated;

  ReportModel({
    required this.id,
    required this.userId,
    required this.plotId,
    required this.projectedRevenue,
    required this.projectedYield,
    required this.dateCreated,
    required this.dateUpdated,
  });
}