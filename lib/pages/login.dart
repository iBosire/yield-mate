import 'dart:developer';

import 'package:yield_mate/pages/home.dart';
import 'package:yield_mate/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:yield_mate/pages/field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yield_mate/services/auth.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _signInFormKey = GlobalKey<FormState>();
  bool obscureText = true;

  // text field values
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/icons/plant-logo.svg', height: 200,),
            const Text(
              'Login',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            // ListView(
            //   shrinkWrap: true,
            //   padding: const EdgeInsets.all(20),
            //   children: [
            //     _signInForm(),
            //   ],
            // ),
            const SizedBox(height: 20),
            Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const FieldPage())
                    );
                  },
                  child: const Text('Login as Farmer'),
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const HomePage())
                      );
                  },
                  child: const Text('Login as Admin'),
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const RegisterPage())
                    );
                  },
                  child: const Text('Register'),
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () async {
                    dynamic result = await _auth.signInAnon();
                    if(result == null) {
                      log('Error signing in');
                    } else {
                      log('Signed in');
                      log(result.uid);
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const HomePage())
                      );
                    }
                  },
                  child: const Text('Sign in Anonymously'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Form _signInForm() {
    const String _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    return Form(
            key: _signInFormKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => email = value,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if(!RegExp(_emailPattern).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) => password = value,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if(_signInFormKey.currentState!.validate()) {
                      log('Validated: email: $email, password: $password');
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        'Welcome to Yeild-Mate',
        style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }
}
