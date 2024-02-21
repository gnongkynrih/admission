import 'dart:convert';
import 'dart:io';

import 'package:admission/model/applicant_model.dart';
import 'package:admission/model/religion_model.dart';
import 'package:admission/provider/admission_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final _personalFormKey = GlobalKey<FormState>();
  ApplicantModel applicant = ApplicantModel();
  final List<String> categories = [];
  final List<ReligionModel> religions = [];
  bool isLoading = true;

  void getInitialValues() async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:8000/api/admission/personal';
    } else {
      url = 'http://localhost:8000/api/admission/personal';
    }
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        // 'Content-Type': 'application/json'
      });
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);

        for (var cat in data['categories']) {
          categories.add(cat);
        }

        for (var rel in data['religions']) {
          // religions.add(ReligionModel.fromJson(rel));
          religions.add(ReligionModel(id: rel['id'], name: rel['name']));
        }
      } else {
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print(' $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getInitialValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.purpleAccent,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                  key: _personalFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (newValue) {
                          applicant.first_name = newValue!;
                        },
                        initialValue: applicant.first_name,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty || value.length < 2) {
                            return 'Invalid First name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        onSaved: (newValue) {
                          applicant.middle_name = newValue!;
                        },
                        initialValue: applicant.middle_name,
                        keyboardType: TextInputType.name,
                        decoration:
                            const InputDecoration(labelText: 'Middle Name'),
                      ),
                      TextFormField(
                        onSaved: (newValue) => applicant.last_name = newValue!,
                        initialValue: applicant.last_name,
                        keyboardType: TextInputType.name,
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                        validator: (String? value) {
                          if (value!.isEmpty || value.length < 2) {
                            return 'Invalid Last name';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'Select Category',
                          // border: OutlineInputBorder(),
                        ),
                        items: categories.map((String category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            applicant.category = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Category is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: 'Select Religion',
                            // border: OutlineInputBorder(),
                          ),
                          items: religions.map((ReligionModel religion) {
                            return DropdownMenuItem(
                              value: religion.id,
                              child: Text(religion.name),
                            );
                          }).toList(),
                          onChanged: (int? value) {
                            setState(() {
                              applicant.religion_id = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Religion is required';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          maximumSize: const Size(120, 50),
                        ),
                        onPressed: () {
                          //check if the form validation is true
                          if (_personalFormKey.currentState!.validate()) {
                            //save the form
                            _personalFormKey.currentState!.save();
                            saveData();
                            //navigate to the next screen
                            // Navigator.pushNamed(context, '/admissionaddress');
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(fontSize: 18),
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      )
                    ],
                  )),
            ),
    );
  }

  void saveData() {
    String url = '';
    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:8000/api/admission/personal';
    } else {
      url = 'http://localhost:8000/api/admission/personal';
    }

    var data = {
      'admission_user_id': '11',
      'first_name': applicant.first_name,
      'last_name': applicant.last_name,
      'middle_name': applicant.middle_name,
      'category': applicant.category,
      'gender': 'Male',
      'dob': '2022-02-01',
      'state': 'Meghalya',
      'nationality': 'Meghalya',
      'religion_id': applicant.religion_id.toString(),
      'language': 'Meghalya',
      'community': 'Meghalya',
      'is_catholic': 'N',
      'balang': '',
      'class_name': 'Three',
    };
    http.post(Uri.parse(url), body: data, headers: {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json'
    }).then((response) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    });
  }
}
