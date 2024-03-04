import 'dart:convert';
import 'dart:io';

import 'package:admission/helpers/common.dart';
import 'package:admission/model/applicant_model.dart';
import 'package:admission/provider/admission_provider.dart';
import 'package:admission/widget/screen/admission/select_image.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UploadDocumentAdmissionScreen extends StatefulWidget {
  const UploadDocumentAdmissionScreen({super.key});

  @override
  State<UploadDocumentAdmissionScreen> createState() =>
      _UploadDocumentAdmissionScreenState();
}

class _UploadDocumentAdmissionScreenState
    extends State<UploadDocumentAdmissionScreen> {
  String applicantId = '';
  ApplicantModel applicant = ApplicantModel();
  bool isLoading = false;

  void getApplicantDetail() async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:8000/api/admission/$applicantId/show';
    } else {
      url = 'http://localhost:8000/api/admission/$applicantId/show';
    }
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        // 'Content-Type': 'application/json'
      });
      if (response.statusCode == 201) {
        var student = jsonDecode(response.body);
        setState(() {
          applicant.passport = student['data']['passport'];
          applicant.father_id = student['data']['father_id'];
          applicant.mother_id = student['data']['mother_id'];
          applicant.birth_certificate = student['data']['birth_certificate'];
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
    applicantId =
        Provider.of<AdmissionProvider>(context, listen: false).applicantId!;
    getApplicantDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Document'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Upload Documents'),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                photoOption(context, 'Passport', 'passport');
              },
              child: ListTile(
                title: const Text('Passport'),
                trailing: FaIcon(applicant.passport != null
                    ? FontAwesomeIcons.squareCheck
                    : FontAwesomeIcons.square),
              ),
            ),
            GestureDetector(
              onTap: () {
                photoOption(context, 'Birth Certificate', 'birth_certificate');
              },
              child: ListTile(
                title: const Text('Birth Certificate'),
                trailing: FaIcon(applicant.birth_certificate != null
                    ? FontAwesomeIcons.squareCheck
                    : FontAwesomeIcons.square),
              ),
            ),
            GestureDetector(
              onTap: () {
                photoOption(context, 'Father Id', 'father_id');
              },
              child: ListTile(
                title: const Text('Father ID'),
                trailing: FaIcon(
                  applicant.father_id != null
                      ? FontAwesomeIcons.squareCheck
                      : FontAwesomeIcons.square,
                  color: applicant.father_id != null
                      ? Colors.greenAccent
                      : Colors.redAccent,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                photoOption(context, 'Mother Id', 'mother_id');
              },
              child: ListTile(
                title: const Text('Mother ID'),
                trailing: FaIcon(applicant.mother_id != null
                    ? FontAwesomeIcons.squareCheck
                    : FontAwesomeIcons.square),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/admissionpayment');
        },
        child: const Text('Make payment'),
      ),
    );
  }

  void photoOption(BuildContext context, String title, String field) async {
    var response = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              height: 350,
              child: SelectImage(
                title: title,
                field: field,
              ));
        });
    if (response == 'ok') {
      getApplicantDetail();
    }
  }
}
