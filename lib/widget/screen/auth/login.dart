import 'dart:convert';

import 'package:admission/helpers/common.dart';
import 'package:admission/model/login_model.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  LoginModel login = LoginModel.initial();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
            child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber.shade100,
              radius: 70,
              child: const FaIcon(FontAwesomeIcons.user,
                  size: 60, color: Colors.deepPurple),
            ),
            const SizedBox(
              height: 80,
            ),
            Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: login.email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        suffixIcon: FaIcon(FontAwesomeIcons.user),
                        border: OutlineInputBorder(),
                        labelText: 'Enter your username',
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Invalid user name';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        login.email = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        onSaved: (newValue) {
                          login.password = newValue!;
                        },
                        initialValue: login.password,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: const InputDecoration(
                          suffixIcon: FaIcon(FontAwesomeIcons.key),
                          border: OutlineInputBorder(),
                          labelText: 'Enter your password',
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Password required';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        //add delay
                        Future.delayed(const Duration(seconds: 3), () {
                          loginnow();
                          setState(() {
                            isLoading = false;
                          });
                        });
                        // loginnow();
                        // setState(() {
                        //   isLoading = false;
                        // });
                      },
                      child: isLoading == true
                          ? const CircularProgressIndicator()
                          : const Text('Login'),
                    ),
                  ],
                ))
          ],
        )),
      ),
    );
  }

  loginnow() async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      String url = 'http://localhost:8000/api/admission/login';
      try {
        var response = await http.post(Uri.parse(url), body: {
          'email': login.email,
          'password': login.password
        }, headers: {
          'Accept': 'application/json',
          // 'Content-Type': 'application/json'
        });
        var data = jsonDecode(response.body);
        if (response.statusCode == 404) {
          CommonHelper.animatedSnackBar(
              context, data['message'], AnimatedSnackBarType.error);
        } else {
          CommonHelper.animatedSnackBar(
              context, data['message'], AnimatedSnackBarType.success);
        }
      } catch (e) {
        print('gordon $e');
      }
    }
  }
}
