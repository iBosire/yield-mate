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
  late PlotModel? _plot;
  final AuthService _auth = AuthService();
  late String currentUser;
  final _formKey = GlobalKey<FormState>();
  late String _plotName;
  late double _plotSize;
  late String _crop;
  late String _regionId;
  late String _seedId;
  late double _seedAmount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _plot = ModalRoute.of(context)!.settings.arguments as PlotModel?;
  }
  
  @override
  void initState() {
    super.initState();
    _auth.user.first.then((user) {
      _auth.user.listen((user) {
        setState(() {
          currentUser = user?.uid ?? 'No user';
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if(widget.type == 'viewplot') {
      return viewPlot();
    } else if(widget.type == 'newplot') {
      return newPlot();
    } else if(widget.type == 'editplot') {
      return editPlot();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
        ),
        body: Center(
          child: Text('Details Page'),
        ),
      );
    }
  }

  Scaffold editPlot() {
    return Scaffold(
      appBar: appBar('Edit Plot', 1),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Details Page'),
      ),
    );
  }

  Scaffold viewPlot() {
    log("Plot ID: ${_plot?.plotId}");
    return Scaffold(
    appBar: appBar('Plot Details', 0),
    backgroundColor: Colors.white,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: _detailsTable(),
          // )
          Text('Plot Name: ${_plot?.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Size: ${_plot?.size.toStringAsFixed(2)} acres'),
          Text('Crop: ${_plot?.crop}'),
          Text('Score: ${_plot?.score}'),
          Text('Region: ${_plot?.regionId}'),
          Text('Seed ID: ${_plot?.seedId}'),
          Text('Seed Amount: ${_plot?.seedAmount} kg'),
          Text('Active: ${_plot?.active}'),
          Text('Date Created: ${_plot?.dateCreated.toDate().day} | ${_plot?.dateCreated.toDate().month} | ${_plot?.dateCreated.toDate().year}'),
          SizedBox(height: 8.0),
          Text('Nutrients:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...?_plot?.nutrients.map((nutrient) => Text('• $nutrient')).toList() ?? [],
        ],
      ),
    ),
  );
  }

  Table _detailsTable() {
    return Table(
      border: const TableBorder(
        verticalInside: BorderSide(
          width: 2,
          color: Colors.grey,
          style: BorderStyle.solid
        )
      ),
      children: [
        TableRow(
          children: [
            TableCell(
              child: Text('Plot Name', textAlign: TextAlign.center,),
            ),
            TableCell(
              child: Text(_plot?.name ?? 'No Name', textAlign: TextAlign.center,),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Size', textAlign: TextAlign.center,),
            ),
            TableCell(
              child: Text('${_plot?.size} acres' ?? 'No Size', textAlign: TextAlign.center,),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Crop', textAlign: TextAlign.center,),
            ),
            TableCell(
              child: Text(_plot?.crop ?? 'No Crop', textAlign: TextAlign.center,),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Status', textAlign: TextAlign.center,),
            ),
            TableCell(
              child: Text('${_plot?.status}' ?? 'No Status', textAlign: TextAlign.center,),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Score', textAlign: TextAlign.center,),
            ),
            TableCell(
              child: Text('${_plot?.score}' ?? 'No Score', textAlign: TextAlign.center,),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Region ID', textAlign: TextAlign.center,),
            ),
            TableCell(
              child: Text(_plot?.regionId ?? 'No Region', textAlign: TextAlign.center,),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Seed ID', textAlign: TextAlign.center,),
            ),
            TableCell(
              child: Text(_plot?.seedId ?? 'No Seed', textAlign: TextAlign.center,),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Seed Amount', textAlign: TextAlign.center,),
            ),
            TableCell(
              child: Text('${_plot?.seedAmount}' ?? 'No Seed Amount', textAlign: TextAlign.center,),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Active', textAlign: TextAlign.center,),
            ),
            TableCell(
              child: Text('${_plot?.active}' ?? 'No Active', textAlign: TextAlign.center,),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Date Created', textAlign: TextAlign.center,),
            ),
            TableCell(
              child: Text('${_plot?.dateCreated.toDate().day} | ${_plot?.dateCreated.toDate().month} | ${_plot?.dateCreated.toDate().year}' ?? 'No Date Created', textAlign: TextAlign.center,),
            ),
          ],
        ),
      ]
    );
  }

  Scaffold newPlot() {
    return Scaffold(
    appBar: appBar('Create Plot', 1),
    backgroundColor: Colors.white,
    body: Center(
      child: plotForm()
    ),
  );
  }

  Form plotForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Plot Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a plot name';
                }
                return null;
              },
              onSaved: (value) {
                _plotName = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Size (acres)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the size of the plot';
                }
                return null;
              },
              onSaved: (value) {
                _plotSize = double.parse(value!);
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Plot Type'),
              items: ['Type 1', 'Type 2', 'Type 3'].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  // Handle change
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a plot type';
                }
                return null;
              },
              onSaved: (value) {
                // Save the selected value
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Crop'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the crop type';
                }
                return null;
              },
              onSaved: (value) {
                _crop = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Region ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the region ID';
                }
                return null;
              },
              onSaved: (value) {
                _regionId = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Seed ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the seed ID';
                }
                return null;
              },
              onSaved: (value) {
                _seedId = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Seed Amount (kg)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the seed amount';
                }
                return null;
              },
              onSaved: (value) {
                _seedAmount = double.parse(value!);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Save plot details
                }
              },
              child: Text('Save Plot'),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(String screenTitle, int type) {
    return AppBar(
      title: Text(
          screenTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back, color: Colors.grey,),
          )
        ),
        actions: [
          _setButton(type)
        ],
    );
  }

  GestureDetector _setButton(int type) {
    // edit button
    if(type == 0){
      return GestureDetector(
          onTap: () async {
            Navigator.pushNamed(context, '/editplot', arguments: _plot);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 37,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.edit, color: Colors.grey, size: 20,),
          ),
        );
    }
    return GestureDetector(
          onTap: () async {
            // 
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 37,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.info, color: Colors.grey, size: 20,),
          ),
        );
  }
}