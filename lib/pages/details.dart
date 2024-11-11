import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yield_mate/models/plot_model.dart';
import 'package:yield_mate/models/user_model.dart';
import 'package:yield_mate/services/auth.dart';
import 'package:yield_mate/services/database.dart';

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

  final AuthService _auth = AuthService();
  late DatabaseService _db;
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
  }
  
  @override
  void initState() {
    super.initState();
    _auth.user.first.then((user) {
      _auth.user.listen((user) {
        setState(() {
          currentUser = user?.uid ?? 'No user';
          _db = DatabaseService(uid: currentUser);
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
  //* Add
 Scaffold newPlot() {
    return Scaffold(
    appBar: appBar('Create Plot', 1, ''),
    backgroundColor: Colors.white,
    body: Center(
      child: plotForm()
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
  //* PlotForm
  Form plotForm() {

  String _plotName;
  double _plotSize;
  String _crop;
  String _regionId;
  String _seedId;
  double _seedAmount;
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

  //? USER Pages
  //* View 
  Scaffold viewUser() {
    return Scaffold(
      appBar: appBar('User Details', 0, '/edituser'),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID: ${_user?.uid}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Email: ${_user?.email}'),
            Text('Name: ${_user?.fName} ${_user?.lName}'),
            Text('Username: ${_user?.username}'),
            Text('Role: ${_user?.type}'),
            Text('Date Created: ${_user?.createdAt?.toDate().day} | ${_user?.createdAt?.toDate().month} | ${_user?.createdAt?.toDate().year}'),
          ],
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
        child: userForm(),
      ),
    );
  }
  //* UserForm
  Form userForm(){
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
              onSaved: (value) {
                // Save the first name
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
              onSaved: (value) {
                // Save the last name
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
              onSaved: (value) {
                // Save the username
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (value) {
                // Save the email
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
              onSaved: (value) {
                // Save the password
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Save user details
                }
              },
              child: Text('Save User'),
            ),
          ],
        ),
      ),
    );
  }

  //? LOCATION Pages
  //* View 
  Scaffold viewLocation() {
    return Scaffold(
      appBar: appBar('Location Details', 0, '/editlocation'),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Details Page'),
      ),
    );
  }
  //* Add 
  Scaffold newLocation() {
    return Scaffold(
      appBar: appBar('Create Location', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Details Page'),
      ),
    );
  }
  //* Edit
  Scaffold editLocation() {
    return Scaffold(
      appBar: appBar('Edit Location', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Details Page'),
      ),
    );
  }
  //* LocationForm
  Form locationForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Location Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location name';
                }
                return null;
              },
              onSaved: (value) {
                // Save the location name
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
                // Save the region ID
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Latitude'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the latitude';
                }
                return null;
              },
              onSaved: (value) {
                // Save the latitude
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Longitude'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the longitude';
                }
                return null;
              },
              onSaved: (value) {
                // Save the longitude
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Save location details
                }
              },
              child: Text('Save Location'),
            ),
          ],
        ),
      ),
    );
  }
  
  //? SEED Pages
  //* View 
  Scaffold viewSeed() {
    return Scaffold(
      appBar: appBar('Seed Details', 0, '/editseed'),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Details Page'),
      ),
    );
  }
  //* Add
  Scaffold newSeed() {
    return Scaffold(
      appBar: appBar('Create Seed', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: seedForm(),
      ),
    );
  }
  //* Edit
  Scaffold editSeed() {
    return Scaffold(
      appBar: appBar('Edit Seed', 1, ''),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Details Page'),
      ),
    );
  }
  //* SeedForm
  Form seedForm(){
    String _seedName = '';
    String _seedManufacturer = '';
    String _seedCrop = '';
    String _seedMaturity = '';

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Seed Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a seed name';
                }
                return null;
              },
              onSaved: (value) {
                _seedName = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Seed Manufacturer'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the seed type';
                }
                return null;
              },
              onSaved: (value) {
                _seedManufacturer = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Seed Crop'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the seed amount';
                }
                return null;
              },
              onSaved: (value) {
                _seedCrop = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Time to Maturity'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the seed price';
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
                  Navigator.pushNamed(context, '/');
                }
              },
              child: Text('Save Seed'),
            ),
          ],
        ),
      ),
    );
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
      body: modelForm('new'),
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
              Text("Edit Model Details", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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