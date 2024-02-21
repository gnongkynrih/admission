import 'dart:convert';
import 'dart:io';

import 'package:admission/model/admission_payment_model.dart';
import 'package:admission/model/applicant_model.dart';
import 'package:admission/provider/admission_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AdmissionDashboard extends StatefulWidget {
  const AdmissionDashboard({super.key});

  @override
  State<AdmissionDashboard> createState() => _AdmissionDashboardState();
}

class _AdmissionDashboardState extends State<AdmissionDashboard> {
  int admission_user_id = 0;
  bool isLoading = true;
  List<ApplicantModel> applicantModel = []; //store all tghe applicant detail
  List<AdmissionPaymentModel> admissionPaymentModel = [];

  @override
  void initState() {
    admission_user_id = Provider.of<AdmissionProvider>(context, listen: false)
        .admission_user_id;
    getApplicantDetails();
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  getApplicantDetails() async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:8000/api/admission/$admission_user_id';
    } else {
      url = 'http://localhost:8000/api/admission/$admission_user_id';
    }
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        // 'Content-Type': 'application/json'
      });
      var data = jsonDecode(response.body);
      for (var item in data['applicants']) {
        applicantModel.add(ApplicantModel.fromJsonDashboard(item));
      }
      for (var pay in data['paidapplicant']) {
        admissionPaymentModel.add(AdmissionPaymentModel.fromJson(pay));
      }
    } catch (e) {
      print(' $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admission Dashboard'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              icon: const FaIcon(FontAwesomeIcons.rightFromBracket),
            ),
          ],
        ),
        body: isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: [
                      for (var item in applicantModel)
                        Card(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                child: Image.network(item.passport!),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(item.first_name!),
                              Text(item.last_name!),
                              Text(item.class_name!),
                            ],
                          ),
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Payment History ${admissionPaymentModel.length}'),
                  Column(
                    children:
                        List.generate(admissionPaymentModel.length, (index) {
                      return Row(
                        children: [
                          Text(admissionPaymentModel[index].r_payment_id),
                          Text(admissionPaymentModel[index].amount),
                          Text(admissionPaymentModel[index].status),
                        ],
                      );
                    }),
                  )
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/admissionpersonal');
          },
          child: const FaIcon(
            FontAwesomeIcons.plus,
            color: Colors.purple,
          ),
        ));
  }
}
