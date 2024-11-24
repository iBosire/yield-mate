
import 'package:flutter/material.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            'Plots',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        ListView.separated(
          itemCount: plots.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          padding: const EdgeInsets.only(left: 20, right: 20),
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff1D1617).withOpacity(0.11),
                    offset: const Offset(0, 10),
                    blurRadius: 40,
                    spreadRadius: 0,
                  )
                ]
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/plot', arguments: plots[index]);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.grass, size: 50,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plots[index]?.name ?? "No Name",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${plots[index]?.size ?? 'Unknown Size'} Acres | Score: ${plots[index]?.score ?? 'Unknown Score'} | Crop: ${plots[index]?.crop ?? 'Unknown Crop'}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
    // return ListView.builder(
    //   itemCount: plots.length,
    //   itemBuilder: (context, index) {
    //     var plot = plots[index];
    //     return ListTile(
    //       title: Text(plot?.name ?? 'No Name'),
    //       subtitle: Text(plot?.crop ?? 'No Crop'),
    //     );
    //   },
    // );
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