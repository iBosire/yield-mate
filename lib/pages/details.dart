import 'package:flutter/material.dart';
import 'package:yield_mate/models/user_model.dart';

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


  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
}