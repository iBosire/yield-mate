import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class PlotList extends StatefulWidget {
  const PlotList({super.key});

  @override
  State<PlotList> createState() => _PlotListState();
}

class _PlotListState extends State<PlotList> {
  @override
  Widget build(BuildContext context) {
    final plots = Provider.of<QuerySnapshot<Object?>?>(context);
    for (var doc in plots!.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      log(data.toString());
    }
    
    if (plots != null) {
      return ListView.builder(
        itemCount: plots.docs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(plots.docs[index]['name']),
            subtitle: Text(plots.docs[index]['crop']),
          );
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}