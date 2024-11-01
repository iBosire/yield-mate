import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:yield_mate/models/plot_model.dart';

class PlotList extends StatefulWidget {
  const PlotList({super.key});

  @override
  State<PlotList> createState() => _PlotListState();
}

class _PlotListState extends State<PlotList> {
  @override
  Widget build(BuildContext context) {
    final plots = Provider.of<List<PlotModel?>?>(context);

    if (plots == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: plots.length,
      itemBuilder: (context, index) {
        var plot = plots[index];
        return ListTile(
          title: Text(plot?.name ?? 'No Name'),
          subtitle: Text(plot?.crop ?? 'No Crop'),
        );
      },
    );
  }
}

//    final plots = Provider.of<QuerySnapshot<Object?>?>(context);

//     if (plots == null) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     for (var doc in plots.docs) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       log(data.toString());
//     }

//     return ListView.builder(
//       itemCount: plots.docs.length,
//       itemBuilder: (context, index) {
//         var data = plots.docs[index].data() as Map<String, dynamic>;
//         return ListTile(
//           title: Text(data['name'] ?? 'No Name'),
//           subtitle: Text(data['crop'] ?? 'No Crop'),
//         );
//       },
//     );