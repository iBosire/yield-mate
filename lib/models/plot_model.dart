import 'package:cloud_firestore/cloud_firestore.dart';

class PlotModel {
  String plotId;
  String name;
  String userId;
  double size;
  int status;
  String crop;
  double score;
  String regionId;
  String region;
  String seedId;
  String seed;
  int seedAmount;
  bool active;
  Timestamp dateCreated;
  Timestamp? dateUpdated;
  List<dynamic> nutrients;
  double predictedYield;
  double predictedRevenue;
  double actualRevenue;
  String recommendedCrop;
  int? yieldAmount;

  PlotModel({
    required this.plotId,
    required this.name,
    required this.userId,
    required this.size,
    required this.status,
    required this.crop,
    required this.score,
    required this.regionId,
    required this.seedId,
    required this.seedAmount,
    required this.active,
    required this.dateCreated,
    required this.nutrients,
    this.yieldAmount,
    this.dateUpdated,
    required this.region,
    required this.seed,
    required this.predictedYield,
    required this.actualRevenue,
    required this.predictedRevenue,
    required this.recommendedCrop,
  });
}