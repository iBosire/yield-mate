
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yield_mate/models/crop_model.dart';
import 'package:yield_mate/models/location_model.dart';
import 'package:yield_mate/models/ml_model.dart';
import 'package:yield_mate/models/plot_model.dart';
import 'package:yield_mate/models/seed_model.dart';
import 'package:yield_mate/models/user_model.dart';
import 'package:http/http.dart' as http;

class DatabaseService {

  final String uid;
  var plots = [];
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference plotCollection = FirebaseFirestore.instance.collection('plots');
  final CollectionReference regionCollection = FirebaseFirestore.instance.collection('regions');
  final CollectionReference seedCollection = FirebaseFirestore.instance.collection('seeds');
  final CollectionReference cropCollection = FirebaseFirestore.instance.collection('crops');
  final CollectionReference modelCollection = FirebaseFirestore.instance.collection('models');

  //? USER functions
  // create new user
  Future createNewUser(String email, String username, String fName, String lName) async {
    await demoPlotData();
    return await userCollection.doc(uid).set({
      'email': email,
      'username': username,
      'fName': fName,
      'lName': lName,
      'type': 'farmer',
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    });
  }
  // update user details
  Future updateUserDetails(String id, String username, String fName, String lName, String type) async {
    return await userCollection.doc(id).update({
      'username': username,
      'fName': fName,
      'lName': lName,
      'type': type,
      'updatedAt': DateTime.now(),
    });
  }
  // delete user
  Future deleteUserAccount(String userId) async {
    final res = await http.post(
      Uri.parse('http://10.0.2.2:5000/delete_user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'uid': userId}),
    );
    log('Response status: ${res.statusCode}');
    return await userCollection.doc(userId).delete();
  }
  // user stream
  Stream<List<UserModel>> get userStream{
    return userCollection.snapshots().map((QuerySnapshot snapshot) => _userListFromSnapshot(snapshot));
  }
  // convert user data from snapshot
  List<UserModel> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
        uid: doc.id,
        username: doc['username'] ?? '',
        fName: doc['fName'] ?? '',
        lName: doc['lName'] ?? '',
        email: doc['email'] ?? '',
        type: doc['type'] ?? '',
        createdAt: doc['createdAt'] ?? '',
        updatedAt: doc['updatedAt'] ?? '',
      );
    }).toList();
  }
  // get user data
  Future<UserModel> getUserData() async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    return UserModel(
      uid: doc.id,
      username: doc['username'] ?? '',
      fName: doc['fName'] ?? '',
      lName: doc['lName'] ?? '',
      email: doc['email'] ?? '',
      type: doc['type'] ?? '',
      createdAt: doc['createdAt'] ?? '',
      updatedAt: doc['updatedAt'] ?? '',
    );
  }
  // delete user
  Future deleteUser(String userId) async {
    return await userCollection.doc(userId).delete();
  }
  // get all users
  Future getUsers() async {
    QuerySnapshot response = await userCollection.where("type", isEqualTo: "farmer").get();
    List<UserModel> users = _userListFromSnapshot(response);
    log("Response from the DB: ${users.length} users");
    return users;
  }
  // total farmers
  Future<int> totalFarmers() async {
    QuerySnapshot response = await userCollection.where("type", isEqualTo: "farmer").get();
    return response.docs.length;
  }
  // average plots per farmer
  Future<double> averagePlotsPerFarmer() async {
    QuerySnapshot response = await userCollection.where("type", isEqualTo: "farmer").get();
    List<UserModel> users = _userListFromSnapshot(response);
    double totalPlots = 0.0;
    for (var _ in users) {
      QuerySnapshot plots = await plotCollection.where('seedId', isNotEqualTo: 'demo').get();
      totalPlots += plots.docs.length;
    }
    return totalPlots / users.length;
  }


  //? PLOT FUNCTIONS
  Future demoPlotData() async {
    return await plotCollection.doc().set({
      'user': uid,
      'name': 'Demo Plot',
      'size': 5.0,
      'status': 0,
      'crop': 'Maize',
      'score': 0,
      'regionId': 'demo',
      'region': 'Demo Region',
      'seedId': 'demo',
      'seed': 'Demo Seed',
      'seedAmount': 50,
      'active': true,
      'yieldAmount': 150,
      'predictedYield': 0.0,
      'actualRevenue': 0.0,
      'predictedRevenue': 0.0,
      'recommendedCrop': '',
      'dateCreated': DateTime.now(),
      'dateUpdated': DateTime.now(),
      'nutrients': [18, 20, 35, 4],
    });
  }
  // create plot
  Future addPlot(String name, String crop, double size, String regionId, String region, String seedId, String seed, int seedAmount, List<int> nutrients) async {
    return await plotCollection.add({
      'user': uid,
      'name': name,
      'size': size,
      'status': 0,
      'crop': crop,
      'score': 0,
      'regionId': regionId,
      'region': region,
      'seedId': seedId,
      'seed': seed,
      'seedAmount': seedAmount,
      'active': true,
      'yieldAmount': 0.0,
      'predictedYield': 0.0,
      'actualRevenue': 0.0,
      'predictedRevenue': 0.0,
      'recommendedCrop': '',
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
  Future updatePlotStatus(String plotId, bool active, double yieldAmount, double revenue) async {
    return await plotCollection.doc(plotId).update({
      'active': active,
      'yieldAmount': yieldAmount,
      'actualRevenue': revenue,
      'dateUpdated': DateTime.now(),
    });
  }
  // delete plot
  Future deletePlot(String plotId) async {
    return await plotCollection.doc(plotId).delete();
  }
  // get plots by user
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
        size: (doc['size'] as num).toDouble(),
        status: (doc['status'] as num).toInt(),
        crop: doc['crop'] ?? '',
        score: (doc['score'] as num).toDouble(),
        regionId: doc['regionId'] ?? '',
        region: doc['region'] ?? '',
        seedId: doc['seedId'] ?? '',
        seed: doc['seed'] ?? '',
        seedAmount: (doc['seedAmount'] as num).toInt(),
        active: doc['active'] ?? false,
        yieldAmount: (doc['yieldAmount'] as num).toDouble(),
        predictedYield: (doc['predictedYield'] as num).toDouble(),
        actualRevenue: (doc['actualRevenue'] as num).toDouble(),
        predictedRevenue: (doc['predictedRevenue'] as num).toDouble(),
        recommendedCrop: doc['recommendedCrop'] ?? '',
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
  // get total yield harvested
  Future<double> getTotalYield() async {
    QuerySnapshot response = await plotCollection.where('user', isEqualTo: uid).get();
    log("Total Yield Response: ${response.docs.length}");
    List<PlotModel> plots = _plotListFromSnapshot(response);
    double totalYield = 0.0;
    for (var plot in plots) {
      if(!plot.active){
        totalYield += (plot.yieldAmount as num).toDouble();
      }
    }
    return totalYield;
  }
  // get total revenue generated
  Future<double> getTotalRevenue() async {
    QuerySnapshot response = await plotCollection.where('user', isEqualTo: uid).get();
    log("Total Revenue Response: ${response.docs.length}");
    List<PlotModel> plots = _plotListFromSnapshot(response);
    double totalRevenue = 0.0;
    for (var plot in plots) {
      if(!plot.active){
        totalRevenue += (plot.actualRevenue as num).toDouble();
      }
    }
    return totalRevenue;
  }
  // most profitable crop
  Future<String> mostProfitableCrop() async {
    QuerySnapshot response = await plotCollection.where('user', isEqualTo: uid).get();
    log("Most Profitable Crop Response: ${response.docs.length}");
    List<PlotModel> plots = _plotListFromSnapshot(response);
    Map<String, double> cropRevenue = {};
    for (var plot in plots) {
      if(!plot.active){
        if(cropRevenue.containsKey(plot.crop)){
          cropRevenue[plot.crop] = cropRevenue[plot.crop]! + (plot.actualRevenue as num).toDouble();
        } else {
          cropRevenue[plot.crop] = (plot.actualRevenue as num).toDouble();
        }
      }
    }
    String mostProfitableCrop = cropRevenue.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    log("Most Profitable Crop: $mostProfitableCrop");
    return mostProfitableCrop;
  }
  // total earnings by crop
  Future<Map<String, double>> earningsByCrop() async {
    QuerySnapshot response = await plotCollection.where('user', isEqualTo: uid).get();
    log("Earnings by Crop Response: ${response.docs.length}");
    List<PlotModel> plots = _plotListFromSnapshot(response);
    Map<String, double> cropRevenue = {};
    for (var plot in plots) {
      if(!plot.active){
        if(cropRevenue.containsKey(plot.crop)){
          cropRevenue[plot.crop] = cropRevenue[plot.crop]! + (plot.actualRevenue as num).toDouble();
        } else {
          cropRevenue[plot.crop] = (plot.actualRevenue as num).toDouble();
        }
      }
    }
    log("Earnings by Crop: $cropRevenue");
    return cropRevenue;
  }

  //? SEED functions
  // add seed
  Future addSeed(String name, String manufacturer, String crop, String timeToMaturity) async {
    return await seedCollection.add({
      'name': name,
      'manufacturer': manufacturer,
      'crop': crop,
      'timeToMaturity': timeToMaturity,
      'dateCreated': DateTime.now(),
      'dateUpdated': DateTime.now(),
    });
  }
  // update seed
  Future updateSeedDetails(String seedId, String name, String manufacturer, String crop, String timeToMaturity) async {
    return await seedCollection.doc(seedId).update({
      'name': name,
      'manufacturer': manufacturer,
      'crop': crop,
      'timeToMaturity': timeToMaturity,
      'dateUpdated': DateTime.now(),
    });
  }
  // delete seed
  Future deleteSeed(String seedId) async {
    return await seedCollection.doc(seedId).delete();
  }
  // get all seeds
  Future<List<SeedModel>> getSeeds() async {
    QuerySnapshot response = await seedCollection.get();
    List<SeedModel> seeds = _seedListFromSnapshot(response);
    log("Response from the DB: ${seeds.length} seeds");
    return seeds;
  }
  // seed stream
  Stream<List<SeedModel>> get seedStream{
    return seedCollection.snapshots().map((QuerySnapshot snapshot) => _seedListFromSnapshot(snapshot));
  }
  List<SeedModel> _seedListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SeedModel(
        id: doc.id,
        name: doc['name'] ?? '',
        manufacturer: doc['manufacturer'] ?? '',
        crop: doc['crop'] ?? '',
        timeToMaturity: doc['timeToMaturity'] ?? '',
        dateCreated: doc['dateCreated'] ?? '',
        dateUpdated: doc['dateUpdated'] ?? '',
      );
    }).toList();
  }
  // most popular seed
  Future<String> mostPopularSeed() async {
    QuerySnapshot response = await plotCollection.where('seedId', isNotEqualTo: 'demo').get();
    log("Most Popular Seed Response: ${response.docs.length}");
    List<PlotModel> plots = _plotListFromSnapshot(response);
    Map<String, int> seedCount = {};
    for (var plot in plots) {
      if(!plot.active){
        if(seedCount.containsKey(plot.seed)){
          seedCount[plot.seed] = seedCount[plot.seed]! + 1;
        } else {
          seedCount[plot.seed] = 1;
        }
      }
    }
    String mostPopularSeed = seedCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    log("Most Popular Seed: $mostPopularSeed");
    return mostPopularSeed;
  }
  // most profitable seed
  Future<String> mostProfitableSeed() async {
    QuerySnapshot response = await plotCollection.where('seedId', isNotEqualTo: 'demo').get();
    log("Most Profitable Seed Response: ${response.docs.length}");
    List<PlotModel> plots = _plotListFromSnapshot(response);
    Map<String, double> seedRevenue = {};
    for (var plot in plots) {
      if(!plot.active){
        if(seedRevenue.containsKey(plot.seed)){
          seedRevenue[plot.seed] = seedRevenue[plot.seed]! + (plot.actualRevenue as num).toDouble();
        } else {
          seedRevenue[plot.seed] = (plot.actualRevenue as num).toDouble();
        }
      }
    }
    String mostProfitableSeed = seedRevenue.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    log("Most Profitable Seed: $mostProfitableSeed");
    return mostProfitableSeed;
  }

  //? MODEL functions
  // add model
  Future addModel(String url, String name, String description) async {
    return await modelCollection.add({
      'url': url,
      'name': name,
      'description': description,
      'dateCreated': DateTime.now(),
      'dateUpdated': DateTime.now(),
    });
  }
  // update model
  Future updateModelDetails(String modelId, String url, String name, String description) async {
    return await modelCollection.doc(modelId).update({
      'url': url,
      'name': name,
      'description': description,
      'dateUpdated': DateTime.now(),
    });
  }
  // delete model
  Future deleteModel(String modelId) async {
    return await modelCollection.doc(modelId).delete();
  }
  // model stream
  Stream<List<MlModel>> get modelStream{
    return modelCollection.snapshots().map((QuerySnapshot snapshot) => _modelListFromSnapshot(snapshot));
  }
  List<MlModel> _modelListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MlModel(
        id: doc.id,
        name: doc['name'] ?? '',
        url: doc['url'] ?? '',
        description: doc['description'] ?? '',
      );
    }).toList();
  }
  // average accuracy of model: compare predicted yield with actual yield
  Future<double> averageModelAccuracy() async {
  QuerySnapshot response = await plotCollection.where('seedId', isNotEqualTo: 'demo').get();
  log("Average Model Accuracy Response: ${response.docs.length}");
  List<PlotModel> plots = _plotListFromSnapshot(response);

  if (plots.isEmpty) return 0.0;
  double totalErrorPercentage = 0.0;
  for (var plot in plots) {
    if (!plot.active) {
      double predictedYield = (plot.predictedYield as num).toDouble();
      double actualYield = (plot.yieldAmount as num).toDouble();

      if (actualYield > 0) {
        double error = ((predictedYield - actualYield).abs() / actualYield) * 100;
        totalErrorPercentage += error;
      } else {
        log("Skipped plot with zero yield: ${plot.plotId}");
      }
    }
  }
  return totalErrorPercentage / plots.length;
}


  //? REGION functions
  // add region
  Future addRegion(String name, String temperature, int rainfall, String humidity) async {
    return await regionCollection.add({
      'name': name,
      'temperature': temperature,
      'rainfall': rainfall,
      'humidity': humidity,
      'dateCreated': DateTime.now(),
      'dateUpdated': DateTime.now(),
    });
  }
  // update region
  Future updateRegionDetails(String regionId, String name, String temperature, int rainfall, String humidity) async {
    return await regionCollection.doc(regionId).update({
      'name': name,
      'temperature': temperature,
      'rainfall': rainfall,
      'humidity': humidity,
      'dateUpdated': DateTime.now(),
    });
  }
  // delete region
  Future deleteRegion(String regionId) async {
    return await regionCollection.doc(regionId).delete();
  }
  // get all regions
  Future<List<LocationModel>> getRegions() async {
    QuerySnapshot response = await regionCollection.get();
    List<LocationModel> regions = _regionListFromSnapshot(response);
    log("Response from the DB: ${regions.length} regions");
    return regions;
  }
  // region stream
  Stream<List<LocationModel>> get regionStream{
    return regionCollection.snapshots().map((QuerySnapshot snapshot) => _regionListFromSnapshot(snapshot));
  }
  List<LocationModel> _regionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return LocationModel(
        id: doc.id,
        name: doc['name'] ?? '',
        temperature: doc['temperature'] ?? '',
        rainfall: doc['rainfall'] ?? 0,
        humidity: doc['humidity'] ?? '',
        dateCreated: doc['dateCreated'] ?? '',
        dateUpdated: doc['dateUpdated'] ?? '',
      );
    }).toList();
  }
  Future<List<String>> getRegionDetails(String regionId) async {
    log("Received Region ID: $regionId");
    DocumentSnapshot doc = await regionCollection.doc(regionId).get();
    return [doc['temperature'], doc['rainfall'].toString(), doc['humidity']];
  }
  // total plots, average yield, and most popular crop for each region
  Future<Map<String, dynamic>> regionStats() async {
    // get all regions
    QuerySnapshot regionResponse = await regionCollection.get();
    log("Region Stats Response: ${regionResponse.docs.length}");
    List<LocationModel> regions = _regionListFromSnapshot(regionResponse);

    // get all plots
    QuerySnapshot plotResponse = await plotCollection.get();
    List<PlotModel> allPlots = _plotListFromSnapshot(plotResponse);

    // group plots by regionId
    Map<String, List<PlotModel>> plotsByRegion = {};
    for (var plot in allPlots) {
      if (!plot.active) { // Only consider inactive plots
        plotsByRegion.putIfAbsent(plot.regionId, () => []).add(plot);
      }
    }

    // Prepare region statistics
    Map<String, dynamic> regionStats = {};
    for (var region in regions) {
      List<PlotModel> regionPlots = plotsByRegion[region.id] ?? [];

      if (regionPlots.isEmpty) {
        // handle empty regions
        regionStats[region.name] = {
          'totalPlots': 0,
          'averageYield': 0.0,
          'mostPopularCrop': 'N/A',
        };
        continue;
      }

      // Calculate total yield and crop counts
      double totalYield = 0.0;
      Map<String, int> cropCount = {};
      for (var plot in regionPlots) {
        totalYield += (plot.yieldAmount as num).toDouble();
        cropCount[plot.crop] = (cropCount[plot.crop] ?? 0) + 1;
      }

      // Find the most popular crop
      String mostPopularCrop = cropCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

      // Populate statistics for the region
      regionStats[region.name] = {
        'totalPlots': regionPlots.length,
        'averageYield': totalYield / regionPlots.length,
        'mostPopularCrop': mostPopularCrop,
      };
    }

    log("Region Stats: $regionStats");
    return regionStats;
  } 

  //? CROP functions
  // add crop
  Future addCrop(String name, String marketPrice) async {
    return await cropCollection.add({
      'name': name,
      'marketPrice': marketPrice,
      'dateCreated': DateTime.now(),
      'dateUpdated': DateTime.now(),
    });
  }
  // update crop
  Future updateCropDetails(String cropId, String name, String marketPrice) async {
    return await cropCollection.doc(cropId).update({
      'name': name,
      'marketPrice': marketPrice,
      'dateUpdated': DateTime.now(),
    });
  }
  // delete crop
  Future deleteCrop(String cropId) async {
    return await cropCollection.doc(cropId).delete();
  }
  // get all crops
  Future<List<CropModel>> getCrops() async {
    QuerySnapshot response = await cropCollection.get();
    List<CropModel> crops = _cropListFromSnapshot(response);
    log("Response from the DB: ${crops.length} crops");
    return crops;
  }
  // crop stream
  Stream<List<CropModel>> get cropStream{
    return cropCollection.snapshots().map((QuerySnapshot snapshot) => _cropListFromSnapshot(snapshot));
  }
  // crop list from snapshot
  List<CropModel> _cropListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CropModel(
        id: doc.id,
        name: doc['name'] ?? '',
        marketPrice: doc['marketPrice'] ?? '',
        dateCreated: doc['dateCreated'] ?? '',
        dateUpdated: doc['dateUpdated'] ?? '',
      );
    }).toList();
  }
  Future<String> getCropPrice(String crop) async {
    DocumentSnapshot doc = await cropCollection.where('name', isEqualTo: crop).get().then((value) => value.docs.first);
    return doc['marketPrice'];
  }
  // most popular and profitable crops
  Future<Map<String, String>> cropStatisticsAll() async {
    QuerySnapshot response = await plotCollection.where('seedId', isNotEqualTo: 'demo').get();
    log("Crop Statistics Response: ${response.docs.length}");
    List<PlotModel> plots = _plotListFromSnapshot(response);

    Map<String, double> cropRevenue = {};
    Map<String, int> cropCount = {};
    for (var plot in plots) {
      if (!plot.active) {
        cropRevenue[plot.crop] = (cropRevenue[plot.crop] ?? 0) + (plot.actualRevenue as num).toDouble();
        cropCount[plot.crop] = (cropCount[plot.crop] ?? 0) + 1;
      }
    }

    // Find the most profitable and most popular crops
    String mostProfitableCrop = cropRevenue.isEmpty
        ? 'No Data'
        : cropRevenue.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    String mostPopularCrop = cropCount.isEmpty
        ? 'No Data'
        : cropCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    log("Most Profitable Crop: $mostProfitableCrop, Most Popular Crop: $mostPopularCrop");
    return {
      'mostProfitableCrop': mostProfitableCrop,
      'mostPopularCrop': mostPopularCrop,
    };
  }
}