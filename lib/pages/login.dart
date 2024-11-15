import 'dart:developer';

import 'package:yield_mate/models/user_model.dart';
import 'package:yield_mate/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:yield_mate/shared/loading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yield_mate/pages/wrapper.dart';
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
  String error = '';
  String _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  bool loading = false;

  // text field values
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset('assets/icons/plant-logo.svg', height: 200,),
              const Text(
                'Login',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                children: [
                  Form(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(120, 40),
                            ),
                            onPressed: () async {
                              if(_signInFormKey.currentState != null && _signInFormKey.currentState!.validate()) {
                                // loading page
                                setState(() {
                                  loading = true;
                                });
                                UserModel? result = await _auth.signInWithEmailAndPassword(email, password);
                              if(result != null){
                                  log("Sign in Result: ${result.uid}");
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => Wrapper())
                                  );
                                } else {
                                  setState(() {
                                    loading = false;
                                    error = "Incorrect Credentials";
                                  });
                                }
                              } else {
                                setState(() {
                                  error = "Please enter valid credentials";
                                });
                              }
                            },
                            child: const Text('Login'),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              fixedSize: const Size(120, 40),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const RegisterPage())
                              );
                            },
                            child: const Text('Register'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        error, 
                        style: const TextStyle(
                          color: Colors.red
                        )
                      ),
                    ],
                  ),
                )
              ],
              ),
              // Column(
              //   children: [
              //     // OutlinedButton(
              //     //   onPressed: () {
              //     //     Navigator.push(
              //     //       context, 
              //     //       MaterialPageRoute(builder: (context) => const HomePage())
              //     //       );
              //     //   },
              //     //   child: const Text('Login as Admin'),
              //     // ),
              //     // const SizedBox(height: 15),
              //     // OutlinedButton(
              //     //   onPressed: () {
              //     //     Navigator.push(
              //     //       context, 
              //     //       MaterialPageRoute(builder: (context) => const RegisterPage())
              //     //     );
              //     //   },
              //     //   child: const Text('Register'),
              //     // ),
              //     // const SizedBox(height: 15),
              //     // OutlinedButton(
              //     //   onPressed: () async {
              //     //     dynamic result = await _auth.signInAnon();
              //     //     if(result == null) {
              //     //       log('Error signing in');
              //     //     } else {
              //     //       log('Signed in');
              //     //       log(result.uid);
              //     //       Navigator.push(
              //     //         context, 
              //     //         MaterialPageRoute(builder: (context) => const HomePage())
              //     //       );
              //     //     }
              //     //   },
              //     //   child: const Text('Sign in Anonymously'),
              //     // ),
              //   ],
              // )
            ],
          ),
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
                      dynamic result = _auth.signInWithEmailAndPassword(email, password);
                      if(result == null){
                        setState(() {
                          error = "Incorrect Credentials";
                        });
                      } else {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => Wrapper())
                        );
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
                SizedBox(height: 10),
                Text(
                  error, 
                  style: const TextStyle(
                    color: Colors.red
                  )
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
