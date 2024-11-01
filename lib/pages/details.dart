import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:yield_mate/models/plot_model.dart';
import 'package:yield_mate/models/user_model.dart';
import 'package:yield_mate/services/auth.dart';

class DetailsPage extends StatefulWidget {
  // use user type to handle what info is displayed (plot details, user details, or model details)

  final UserModel? user;
  final String? type;
  const DetailsPage({
    super.key,
    this.user,
    this.type,
  });

  @override
  State<DetailsPage> createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  late PlotModel _plot;
  final AuthService _auth = AuthService();
  late String currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _plot = ModalRoute.of(context)!.settings.arguments as PlotModel;
  }
  
  @override
  Widget build(BuildContext context) {
    _auth.user.listen((user) {
      currentUser = user?.uid ?? 'No user';
    }); // Ensure this is awaited if necessary

    log("Plot ID: ${_plot.plotId}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Plot Details'),
      ),
      body: Center(
        child: Text('Plot Name: ${_plot.name}'),
      ),
    );
  }
  
}