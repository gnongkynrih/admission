import 'dart:convert';
import 'dart:io';

import 'package:admission/model/applicant_model.dart';
import 'package:admission/provider/admission_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  String applicantID = '';
  ApplicantModel applicant = ApplicantModel();
  void getApplicantDetail() async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:8000/api/admission/$applicantID/show';
    } else {
      url = 'http://localhost:8000/api/admission/$applicantID/show';
    }
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        // 'Content-Type': 'application/json'
      });
      if (response.statusCode == 201) {
        var student = jsonDecode(response.body);
        setState(() {
          applicant.mother_name = student['data']['mother_name'];
          applicant.father_name = student['data']['father_name'];
          applicant.first_name = student['data']['first_name'];
          applicant.last_name = student['data']['last_name'];
        });
      } else {
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print(' $e');
    }
  }

  @override
  void initState() {
    applicantID =
        Provider.of<AdmissionProvider>(context, listen: false).applicantId!;
    getApplicantDetail();
    super.initState();
  }

  final familyFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${applicant.first_name} ${applicant.last_name}'),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: familyFormKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Father Name',
                    ),
                    initialValue: applicant.father_name,
                    validator: (String? father) {
                      if (father!.isEmpty) {
                        return 'Please enter father name';
                      }
                      return null;
                    },
                    onSaved: (father) {
                      applicant.father_name = father!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Mother Name',
                    ),
                    initialValue: applicant.mother_name,
                    validator: (mother) {
                      if (mother!.isEmpty) {
                        return 'Please enter mother name';
                      }
                      return null;
                    },
                    onSaved: (mother) {
                      applicant.mother_name = mother!;
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      maximumSize: const Size(120, 50),
                    ),
                    onPressed: () {
                      if (familyFormKey.currentState!.validate()) {
                        familyFormKey.currentState!.save();
                        saveFamily();
                        // Navigator.pushNamed(context, '/admissiondashboard');
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
              ),
            )),
      ),
    );
  }

  void saveFamily() {
    var data = {
      'father_name': applicant.father_name,
      'mother_name': applicant.mother_name,
      'father_occupation': 'test',
      'mother_occupation': 'hello',
      'father_phone': 'test',
      'mother_phone': 'test',
      'corresponding_address': 'hello',
      'permanent_address': 'hello',
      'father_designation': 'str',
      'mother_designation': 'str',
      'boys': '1',
      'girls': '2',
      'total_members': '3',
    };
    String url = '';
    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:8000/api/admission/parents/$applicantID';
    } else {
      url = 'http://localhost:8000/api/admission/parents/$applicantID';
    }
    http.put(Uri.parse(url), body: data, headers: {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json'
    }).then((response) {
      Navigator.pushNamed(context, '/admissionupload');
    });
  }
}
