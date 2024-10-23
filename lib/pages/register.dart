import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yield_mate/services/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _obscureTextP = true;
  bool _obscureTextC = true;
  String _password = '';

  // text fields
  String _firstName = '';
  String _lastName = '';
  String _username = '';
  String _email = '';


  final String _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Registration'),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Please Enter Your Details',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 30),
                // FIRST NAME
                TextFormField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    helperText: ' ',
                    hintText: 'First Name',
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      ),
                  ),
                  onChanged: (value) => _firstName = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // LAST NAME
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    helperText: ' ',
                    hintText: 'Last Name',
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => _lastName = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // USERNAME
                TextFormField(
                  decoration: InputDecoration(
                    helperText: ' ',
                    hintText: 'Username',
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => _username = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a username';
                    } else if (value.length < 4) {
                      return 'Username must be at least 4 characters';
                    } else if (value.length > 20) {
                      return 'Username cannot be more than 20 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // EMAIL
                TextFormField(
                  decoration: InputDecoration(
                    helperText: ' ',
                    hintText: 'Email',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => _email = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(_emailPattern).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // PASSWORD
                TextFormField(
                  obscureText: _obscureTextP,
                  decoration: InputDecoration(
                    helperText: ' ',
                    hintText: 'Password',
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureTextP ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureTextP = !_obscureTextP;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Please enter a password that is at least 6 characters long';
                    }
                    _password = value;
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // CONFIRM PASSWORD
                TextFormField(
                  obscureText: _obscureTextC,
                  decoration: InputDecoration(
                    helperText: ' ',
                    hintText: 'Confirm Password',
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureTextC ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureTextC = !_obscureTextC;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value != _password) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // REGISTER BUTTON
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                          backgroundColor: Colors.teal,
                        ),
                      );
                      log('First Name: $_firstName, Last Name: $_lastName, Username: $_username, Email: $_email, Password: $_password');
                      dynamic result = await _auth.registerWithEmailAndPassword(_email, _password);
                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error registering user'),
                            backgroundColor: Colors.teal,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please make sure all fields are filled in'),
                          backgroundColor: Colors.teal,
                        )
                      );
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar(String screenTitle) {
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
          child: SvgPicture.asset(
            'assets/icons/back.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {

          },
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 37,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              'assets/icons/settings.svg',
              height: 20,
              width: 20,
            )
          ),
        ),
      ],
    );
  }
}