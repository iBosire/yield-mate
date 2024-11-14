import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:yield_mate/models/plot_model.dart';
import 'package:yield_mate/models/user_model.dart';
import 'package:yield_mate/services/auth.dart';
import 'package:yield_mate/services/database.dart';
import 'package:yield_mate/services/model.dart';

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
  late dynamic _plot;
  late dynamic _user;
  late dynamic _location;
  late dynamic _seed;
  late dynamic _model;
  late dynamic _crop;

  final AuthService _auth = AuthService();
  late DatabaseService _db;
  late PlotAnalysisService _plotModels;
  late String currentUser;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _plot = ModalRoute.of(context)!.settings.arguments;
    _user = ModalRoute.of(context)!.settings.arguments;
    _location = ModalRoute.of(context)!.settings.arguments;
    _seed = ModalRoute.of(context)!.settings.arguments;
    _model = ModalRoute.of(context)!.settings.arguments;
    _crop = ModalRoute.of(context)!.settings.arguments;
  }
  
  @override
  void initState() {
    super.initState();
    _auth.user.first.then((user) {
      _auth.user.listen((user) {
        setState(() {
          currentUser = user?.uid ?? 'No user';
          _db = DatabaseService(uid: currentUser);
          _plotModels = PlotAnalysisService('http://10.0.2.2:5000');
        });
      });
    });
  }

  //* Check type of page to display 
  @override
  Widget build(BuildContext context) {
    if(widget.type == 'viewplot') {
      return viewPlot();
    } else if(widget.type == 'newplot') {
      return newPlot();
    } else if(widget.type == 'editplot') {
      return editPlot();
    } else if(widget.type == 'viewuser') {
      return viewUser();
    } else if(widget.type == 'edituser') {
      return editUser();
    } else if(widget.type == 'viewlocation') {
      return viewLocation();
    } else if(widget.type == 'newlocation') {
      return newLocation();
    } else if(widget.type == 'editlocation') {
      return editLocation();
    } else if(widget.type == 'viewseed') {
      return viewSeed();
    } else if(widget.type == 'newseed') {
      return newSeed();
    } else if(widget.type == 'editseed') {
      return editSeed();
    } else if(widget.type == 'viewmodel') {
      return viewModel();
    } else if(widget.type == 'newmodel') {
      return newModel();
    } else if(widget.type == 'editmodel') {
      return editModel();
    } else if(widget.type == 'viewcrop') {
      return viewCrop();
    } else if(widget.type == 'newcrop') {
      return newCrop();
    } else if(widget.type == 'editcrop') {
      return editCrop();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  //? PLOT Pages
  //* Edit
  Scaffold editPlot() {
    return Scaffold(
      appBar: appBar('Edit Plot', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Details Page'),
      ),
    );
  }
  //* View
  Scaffold viewPlot() {
    log("Plot ID: ${_plot?.plotId}");
    return Scaffold(
    appBar: appBar('Plot Details', 0, '/editplot'),
    backgroundColor: Colors.white,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            plotForm('view'),
          ],
        ),
      ),
    ),
  );
  }
  //* Add
 Scaffold newPlot() {
    return Scaffold(
    appBar: appBar('Create Plot', 1, ''),
    backgroundColor: Colors.white,
    body: Center(
      child: plotForm('new'),
    ),
  );
  }
  // TODO: add to viewPlot
  //* Soil Nutrition Table
  Table _detailsTable(dynamic nutrients) {
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
              child: Text('${_plot?.size} acres', textAlign: TextAlign.center,),
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
              child: Text('${_plot?.seedAmount}', textAlign: TextAlign.center,),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Active', textAlign: TextAlign.center,),
            ),
            TableCell(
              child: Text('${_plot?.active}', textAlign: TextAlign.center,),
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
  //* PlotForm
  Form plotForm(String type) {
    dynamic seeds = _db.getSeeds();
    dynamic regions = _db.getRegions();
    dynamic crops = _db.getCrops();
    String _plotName = '';
    double _plotSize = 0.0;
    String _crop = '';
    String _regionId = '';
    String _seedId = '';
    int _seedAmount = 0;
    int _nitrogen = 0;
    int _phosphorus = 0;
    int _potassium = 0;
    int _ph = 0;

    if(type == 'view'){
      return Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              decoration: decorator("Plot Name", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _plot?.name,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Size", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _plot?.size.toString(),
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Crop", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _plot?.crop,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Status", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _plot?.status,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Score", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _plot?.score.toString(),
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Region ID", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _plot?.regionId,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Seed ID", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _plot?.seedId,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Seed Amount", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _plot?.seedAmount.toString(),
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Active", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _plot?.active.toString(),
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Date Created", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: '${_plot?.dateCreated.toDate().day} | ${_plot?.dateCreated.toDate().month} | ${_plot?.dateCreated.toDate().year}',
              readOnly: true,
            ),
          ],
        ),
      );
    } else if(type == 'new'){
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: decorator('Plot Name', '', 'Enter the plot name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the plot name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _plotName = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Size', '', 'Enter the plot size'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the plot size';
                  }
                  return null;
                },
                onSaved: (value) {
                  _plotSize = double.parse(value!);
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField(
                decoration: decorator('Crop', '', 'Select the crop'),
                dropdownColor: Colors.white,
                items: crops.map((crop) {
                  return DropdownMenuItem(
                    alignment: Alignment.center,
                    value: crop['name'],
                    child: Text(crop['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _crop = value.toString();
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField(
                decoration: decorator('Region ID', '', 'Select the region'),
                dropdownColor: Colors.white,
                items: regions.map((region) {
                  return DropdownMenuItem(
                    alignment: Alignment.center,
                    value: region['id'],
                    child: Text(region['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _regionId = value.toString();
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField(
                decoration: decorator('Seed ID', '', 'Select the seed'),
                dropdownColor: Colors.white,
                items: seeds.map((seed) {
                  return DropdownMenuItem(
                    alignment: Alignment.center,
                    value: seed['id'],
                    child: Text(seed['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _seedId = value.toString();
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Seed Amount', '', 'Enter the seed amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seed amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  _seedAmount = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              //* nutrition details
              TextFormField(
                decoration: decorator('Nitrogen', '', 'Enter the nitrogen amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the nitrogen amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nitrogen = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Phosphorus', '', 'Enter the phosphorus amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the phosphorus amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phosphorus = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Potassium', '', 'Enter the potassium amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the potassium amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  _potassium = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('pH', '', 'Enter the pH'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pH';
                  }
                  return null;
                },
                onSaved: (value) {
                  _ph = int.parse(value!);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    List<int> _nutrition = [_nitrogen, _phosphorus, _potassium, _ph];
                    _db.addPlot(_plotName, _crop, _plotSize, _regionId, _seedId, _seedAmount.toInt(), _nutrition, 0);
                    Navigator.pushNamed(context, '/modeltab');
                  }
                },
                child: Text('Save Plot'),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Form(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
  // TODO: Implement editPlot

  // TODO: run plot analysis on new plot
  void _analyzePlot(String n, String p, String k, String temp, String hum, String r, String ph) async {
    final plotData = {
      'Nitrogen': n,
      'Phosphorus': p,
      'Potassium': k,
      'Temperature': temp,
      'Humidity': hum,
      'Rainfall': r,
      'pH': ph,
    };
    final result = await _plotModels.analyzePlot(jsonEncode(plotData));
    log('Result: $result');
  }
  //? USER Pages
  //* View 
  Scaffold viewUser() {
    return Scaffold(
      appBar: appBar('User Details', 0, '/edituser'),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('User Details', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ID: ${_user?.uid}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _user?.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ID copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Icon(Icons.copy, color: Colors.grey, size: 20,),
                  )
                ],
              ),
              SizedBox(height: 20),
              userForm('view'),
              SizedBox(height: 10),
              Text('Date Created: ${_user?.createdAt.toDate().day} | ${_user?.createdAt.toDate().month} | ${_user?.createdAt.toDate().year}'),
              Text('Date Updated: ${_user?.updatedAt.toDate().day} | ${_user?.updatedAt.toDate().month} | ${_user?.updatedAt.toDate().year} | Time ${_user?.updatedAt.toDate().hour}:${_user?.updatedAt.toDate().minute}'),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(200, 50),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete User'),
                        content: const Text('Are you sure you want to delete this user?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await _db.deleteUser(_user?.uid);
                              Navigator.pushNamed(context, '/modeltab');
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Delete User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  //* Edit
  Scaffold editUser() {
    return Scaffold(
      appBar: appBar('Edit User', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Edit User Details', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w400)),
            userForm('edit'),
          ],
        ),
      ),
    );
  }
  //* UserForm
  Form userForm(String type){
    if(type == 'view'){
      return Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              decoration: decorator("First Name", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _user?.fName,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Last Name", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _user?.lName,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Username", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _user?.username,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Type", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _user?.type,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Email", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _user?.email,
              readOnly: true,
            ),
          ],
        ),
      );
    } else if(type == 'edit'){
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: decorator('First Name', "", 'Enter first name'),
                initialValue: _user?.fName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _user.fName = value;
                },
              ),
              TextFormField(
                decoration: decorator('Last Name', "", 'Enter last name'),
                initialValue: _user?.lName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an last name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _user.lName = value;
                },
              ),
              DropdownButtonFormField(
                decoration: decorator('Type', "", 'Select user type'),
                dropdownColor: Colors.white,
                items: ['admin', 'farmer'].map((String type) {
                  return DropdownMenuItem(
                    alignment: Alignment.center,
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _user.type = value.toString();
                  });
                },
              ),
              TextFormField(
                decoration: decorator('Username', "", 'Enter new username'),
                initialValue: _user?.username,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _user.username = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _db.updateUserDetails(_user.uid, _user?.username, _user?.fName, _user?.lName, _user?.type);
                    Navigator.pushNamed(context, '/');
                  }
                },
                child: Text('Save User'),
              ),
            ],
          ),
        ),
      );
    } else {
    return const Form(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

  //? LOCATION Pages
  //* View 
  Scaffold viewLocation() {
    return Scaffold(
      appBar: appBar('Location Details', 0, '/editlocation'),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Location Details", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ID: ${_location?.id}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _location?.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ID copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Icon(Icons.copy, color: Colors.grey, size: 20,),
                  )
                ],
              ),
              SizedBox(height: 20),
              locationForm('view'),
              SizedBox(height: 10),
              Text('Date Created: ${_location?.dateCreated.toDate().day} | ${_location?.dateCreated.toDate().month} | ${_location?.dateCreated.toDate().year}'),
              Text('Date Updated: ${_location?.dateUpdated.toDate().day} | ${_location?.dateUpdated.toDate().month} | ${_location?.dateUpdated.toDate().year}'),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(200, 50),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Location'),
                        content: const Text('Are you sure you want to delete this location?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await _db.deleteRegion(_location?.id);
                              Navigator.pushNamed(context, '/modeltab');
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Delete Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  //* Add 
  Scaffold newLocation() {
    return Scaffold(
      appBar: appBar('Create Location', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Add New Location', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
            SizedBox(height: 20),
            locationForm('new'),
          ],
        ),
      ),
    );
  }
  //* Edit
  Scaffold editLocation() {
    return Scaffold(
      appBar: appBar('Edit Location', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: locationForm('edit'),
      ),
    );
  }
  //* LocationForm
  Form locationForm(String type) {
    String _locationName = '';
    String _locationTemperature = '';
    String _locationHumidity = '';
    int _locationRainfall = 0;

    if(type == "new"){
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: decorator('Location Name', 'Nairobi', 'Enter the location name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _locationName = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Temperature', '25', 'Enter the average temperature in Celsius'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the temperature';
                  }
                  return null;
                },
                onSaved: (value) {
                  _locationTemperature = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Humidity', '60%', 'Enter the humidity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the humidity';
                  }
                  return null;
                },
                onSaved: (value) {
                  _locationHumidity = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Rainfall', '100mm', 'Enter the rainfall'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the rainfall';
                  }
                  return null;
                },
                onSaved: (value) {
                  _locationRainfall = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _db.addRegion(_locationName, _locationTemperature, _locationRainfall, _locationHumidity);
                    Navigator.pushNamed(context, '/modeltab');
                  }
                },
                child: Text('Save Location'),
              ),
            ],
          ),
        ),
      );
    } else if(type == "view"){
      return Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              decoration: decorator("Location Name", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _location?.name,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Temperature", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _location?.temperature,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Humidity", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _location?.humidity,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Rainfall", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _location?.rainfall.toString(),
              readOnly: true,
            ),
          ],
        ),
      );
    } else if(type == "edit"){
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Edit Location Details', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w400)),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Location Name', _location?.name, 'Enter the location name'),
                initialValue: _location?.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _locationName = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Temperature', _location?.temperature, 'Enter the temperature'),
                initialValue: _location?.temperature,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the temperature';
                  }
                  return null;
                },
                onSaved: (value) {
                  _locationTemperature = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Humidity', _location?.humidity, 'Enter the humidity'),
                initialValue: _location?.humidity,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the humidity';
                  }
                  return null;
                },
                onSaved: (value) {
                  _locationHumidity = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Rainfall', "", 'Enter the rainfall'),
                initialValue: _location?.rainfall.toString(),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the rainfall';
                  }
                  return null;
                },
                onSaved: (value) {
                  _locationRainfall = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _db.updateRegionDetails(_location?.id, _locationName, _locationTemperature, _locationRainfall, _locationHumidity);
                    Navigator.pushNamed(context, '/modeltab');
                  }
                },
                child: Text('Save Location'),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Form(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
  
  //? SEED Pages
  //* View 
  Scaffold viewSeed() {
    return Scaffold(
      appBar: appBar('Seed Details', 0, '/editseed'),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Seed Details", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ID: ${_seed?.id}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _seed?.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ID copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Icon(Icons.copy, color: Colors.grey, size: 20,),
                  )
                ],
              ),
              SizedBox(height: 20),
              seedForm('view'),
              SizedBox(height: 10),
              Text('Date Created: ${_seed?.dateCreated.toDate().day} | ${_seed?.dateCreated.toDate().month} | ${_seed?.dateCreated.toDate().year}'),
              Text('Date Updated: ${_seed?.dateUpdated.toDate().day} | ${_seed?.dateUpdated.toDate().month} | ${_seed?.dateUpdated.toDate().year}'),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(200, 50),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Seed'),
                        content: const Text('Are you sure you want to delete this seed?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await _db.deleteSeed(_seed?.id);
                              Navigator.pushNamed(context, '/modeltab');
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Delete Seed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //* Add
  Scaffold newSeed() {
    return Scaffold(
      appBar: appBar('Create Seed', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Add New Seed', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
            seedForm('new'),
          ],
        ),
      ),
    );
  }
  //* Edit
  Scaffold editSeed() {
    return Scaffold(
      appBar: appBar('Edit Seed', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: seedForm('edit'),
      ),
    );
  }
  //* SeedForm
  Form seedForm(String type){
    String _seedName = '';
    String _seedManufacturer = '';
    String _seedCrop = '';
    String _seedMaturity = '';

    if(type == "new"){
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: decorator('Seed Name', 'Maize', 'Enter the seed name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seed name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _seedName = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Seed Manufacturer', 'Seed Co.', 'Enter the seed manufacturer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seed manufacturer';
                  }
                  return null;
                },
                onSaved: (value) {
                  _seedManufacturer = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Seed Crop', 'Maize', 'Enter the seed crop'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seed crop';
                  }
                  return null;
                },
                onSaved: (value) {
                  _seedCrop = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Seed Maturity', '90 days', 'Enter the days to maturity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seed maturity';
                  }
                  return null;
                },
                onSaved: (value) {
                  _seedMaturity = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _db.addSeed(_seedName, _seedManufacturer, _seedCrop, _seedMaturity);
                    Navigator.pushNamed(context, '/modeltab');
                  }
                },
                child: Text('Save Seed'),
              ),
            ],
          ),
        ),
      );
    } else if(type == "view"){
      return Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              decoration: decorator("Seed Name", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _seed?.name,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Seed Manufacturer", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _seed?.manufacturer,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Seed Crop", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _seed?.crop,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Seed Maturity", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _seed?.timeToMaturity,
              readOnly: true,
            ),
          ],
        ),
      );
    } else if(type == "edit"){
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Edit Seed Details', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w400)),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Seed Name', _seed?.name, 'Enter the seed name'),
                initialValue: _seed?.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seed name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _seedName = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Seed Manufacturer', _seed?.manufacturer, 'Enter the seed manufacturer'),
                initialValue: _seed?.manufacturer,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seed manufacturer';
                  }
                  return null;
                },
                onSaved: (value) {
                  _seedManufacturer = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Seed Crop', _seed?.crop, 'Enter the seed crop'),
                initialValue: _seed?.crop,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seed crop';
                  }
                  return null;
                },
                onSaved: (value) {
                  _seedCrop = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Seed Maturity', _seed?.timeToMaturity, 'Enter the seed maturity'),
                initialValue: _seed?.timeToMaturity,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seed maturity';
                  }
                  return null;
                },
                onSaved: (value) {
                  _seedMaturity = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _db.updateSeedDetails(_seed?.id, _seedName, _seedManufacturer, _seedCrop, _seedMaturity);
                    Navigator.pushNamed(context, '/modeltab');
                  }
                },
                child: Text('Save Seed'),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Form(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  //? MODEL Pages
  //* View
  Scaffold viewModel() {
    return Scaffold(
      appBar: appBar('Model Details', 0, '/editmodel'),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ID: ${_model?.id}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _model?.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ID copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Icon(Icons.copy, color: Colors.grey, size: 20,),
                  )
                ],
              ),
              SizedBox(height: 20),
              modelForm("view"),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Model'),
                        content: Text('Are you sure you want to delete this model?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _db.deleteModel(_model?.id);
                              Navigator.pushNamed(context, '/');
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () async {
                  // ping model
                  dynamic res = await _plotModels.ping();
                  log("Response Message: $res");
                  if (res['response'] == 'pong') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Model is online'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Model is offline'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                label: const Text('Ping Model'),
                icon: const Icon(Icons.send),
              )
              // Text('Date Created: ${_model?.dateCreated.toDate().day} | ${_model?.dateCreated.toDate().month} | ${_model?.dateCreated.toDate().year}'),
            ],
          ),
        ),
      ),
    );
  }
  //* Add
  Scaffold newModel() {
    return Scaffold(
      appBar: appBar('Create Model', 1, ''),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Add New Model', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
          modelForm('new'),
        ],
      ),
    );
  }
  //* Edit
  Scaffold editModel() {
    return Scaffold(
      appBar: appBar('Edit Model', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Edit Model Details", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              modelForm('edit'),
            ],
          ),
        ),
      ),
    );
  }
  //* ModelForm
  Form modelForm(String type) {
    String _modelName = '';
    String _modelDescription = '';
    String _modelUrl = '';

    if(type == 'new'){
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: decorator('Model Name', "Yield Predictor", 'Enter the model name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a model name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _modelName = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Model Descryption', "predict crop yield", 'Enter a short description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the model description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _modelDescription = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator("Model URL", "www.model.com/yield", "enter the model URL"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the model URL';
                  }
                  return null;
                },
                onSaved: (value) {
                  _modelUrl = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _db.addModel(_modelUrl, _modelName, _modelDescription);
                    Navigator.pushNamed(context, '/modeltab');
                  }
                },
                child: Text('Save Model'),
              ),
            ],
          ),
        ),
      );
    } else if(type == "view"){
      return Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              decoration: decorator("Model Name", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _model?.name,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Model Description", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _model?.description,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Model URL", "", ""),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _model?.url,
              readOnly: true,
            ),
          ],
        ),
      );
    } else if (type == 'edit'){
      return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Edit Model Details', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w400)),
            SizedBox(height: 20),
            TextFormField(
              decoration: decorator("Model Name", "", ""),
              style: const TextStyle(
                fontSize: 18,
              ),
              initialValue: _model?.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a model name';
                }
                return null;
              },
              onSaved: (value) {
                _modelName = value!;
              },
            ),
            TextFormField(
              decoration: decorator("Model Description", "", ""),
              style: const TextStyle(
                fontSize: 18,
              ),
              initialValue: _model?.description,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the model description';
                }
                return null;
              },
              onSaved: (value) {
                _modelDescription = value!;
              },
            ),
            TextFormField(
              decoration: decorator("Model URL", "", ""),
              style: const TextStyle(
                fontSize: 18,
              ),
              initialValue: _model?.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the model URL';
                }
                return null;
              },
              onSaved: (value) {
                _modelUrl = value!;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await _db.updateModelDetails(_model?.id, _modelUrl, _modelName, _modelDescription);
                  Navigator.pushNamed(context, '/modeltab');
                }
              },
              child: const Text('Save Model'),
            ),
          ],
        ),
      );
    } else {
      return const Form(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  //? CROP Pages
  //* View
  Scaffold viewCrop() {
    return Scaffold(
      appBar: appBar('Crop Details', 0, '/editcrop'),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ID: ${_crop?.id}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _crop?.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ID copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Icon(Icons.copy, color: Colors.grey, size: 20,),
                  )
                ],
              ),
              SizedBox(height: 20),
              cropForm('view'),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Crop'),
                        content: const Text('Are you sure you want to delete this crop?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await _db.deleteCrop(_crop?.id);
                              Navigator.pushNamed(context, '/modeltab');
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Delete Crop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //* Add
  Scaffold newCrop() {
    return Scaffold(
      appBar: appBar('Create Crop', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Add New Crop', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
            cropForm('new'),
          ],
        ),
      ),
    );
  }
  //* Edit
  Scaffold editCrop() {
    return Scaffold(
      appBar: appBar('Edit Crop', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: cropForm('edit'),
      ),
    );
  }
  //* CropForm
  Form cropForm(String type) {
    String _cropName = '';
    String _cropMarketPrice = '';

    if(type == "new"){
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: decorator('Crop Name', 'Maize', 'Enter the crop name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the crop name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cropName = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Crop Market Price', '20', 'Enter the market price in ksh per kg.'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the crop variety';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cropMarketPrice = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _db.addCrop(_cropName, _cropMarketPrice);
                    Navigator.pushNamed(context, '/modeltab');
                  }
                },
                child: Text('Save Crop'),
              ),
            ],
          ),
        ),
      );
    } else if(type == "view"){
      return Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              decoration: decorator("Crop Name", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _crop?.name,
              readOnly: true,
            ),
            TextFormField(
              decoration: decorator("Crop Market Price", "", ""),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              initialValue: _crop?.marketPrice,
              readOnly: true,
            ),
          ],
        ),
      );
    } else if(type == "edit"){
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Edit Crop Details', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w400)),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Crop Name', _crop?.name, 'Enter the crop name'),
                initialValue: _crop?.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the crop name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cropName = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: decorator('Crop Market Price', _crop?.marketPrice, 'Enter the crop market price in ksh per kg.'),
                initialValue: _crop?.marketPrice,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the crop description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cropMarketPrice = value!;
                },
              ), 
              SizedBox(height: 20),
              Text('Date Created: ${_crop?.dateCreated.toDate().day} | ${_crop?.dateCreated.toDate().month} | ${_crop?.dateCreated.toDate().year}'),
              Text('Date Updated: ${_crop?.dateUpdated.toDate().day} | ${_crop?.dateUpdated.toDate().month} | ${_crop?.dateUpdated.toDate().year} | Time: ${_crop?.dateUpdated.toDate().hour} : ${_crop?.dateUpdated.toDate().minute}'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _db.updateCropDetails(_crop?.id, _cropName, _cropMarketPrice);
                    Navigator.pushNamed(context, '/modeltab');
                  }
                },
                child: Text('Save Crop'),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Form(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  //? Form Input Decorations
  InputDecoration decorator(String label, String hint, String helper) {
    return InputDecoration(
      helperText: helper,
      hintText: hint,
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
  //? APPBAR 
  AppBar appBar(String screenTitle, int type, String route) {
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
          _setButton(type, route),
        ],
    );
  }

  //? AppBar Buttons
  GestureDetector _setButton(int type, String route) {
    //* edit button
    if(type == 0){
      return GestureDetector(
        onTap: () async {
          Navigator.pushNamed(context, route, arguments: _plot);
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
    //* info button
    return GestureDetector(
      onTap: () {
        // TODO: Add info page
        showDialog(
          context: context, 
          builder: (BuildContext context) => Dialog.fullscreen(
            child: Column(
              children: [
                const Text('Info Page'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
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