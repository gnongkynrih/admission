import 'dart:convert';
import 'dart:io';
import 'package:admission/model/applicant_model.dart';
import 'package:admission/model/class_model.dart';
import 'package:admission/model/religion_model.dart';
import 'package:admission/provider/admission_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
  final List<ClassModel> classes = [];
  bool isLoading = true;
  List<DateTime> dob = [];
  String? applicantID;
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

        for (var cls in data['admissiontoclass']) {
          classes.add(ClassModel.fromJson(cls));
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

  void getApplicantDetail() async {
    if (applicantID == null) {
      return;
    }
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
        DateTime dt = DateFormat('dd-mm-yyyy').parse(student['data']['dob']);
        setState(() {
          applicant = ApplicantModel(
            first_name: student['data']['first_name'],
            middle_name: student['data']['middle_name'],
            last_name: student['data']['last_name'],
            gender: student['data']['gender'],
            is_catholic: student['data']['is_catholic'],
            balang: student['data']['balang'],
            category: student['data']['category'],
            class_name: student['data']['class_name'],
            religion_id: student['data']['religion_id'],
            dob: dt,
          );
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
    getInitialValues();
    setState(() {
      applicantID =
          Provider.of<AdmissionProvider>(context, listen: false).applicantId;
    });
    getApplicantDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(applicantID == null ? 'Admission' : applicantID!),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.purpleAccent,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                    key: _personalFormKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField(
                          value: applicant.class_name,
                          decoration: const InputDecoration(
                            labelText: 'Admission to class',
                            // border: OutlineInputBorder(),
                          ),
                          items: classes.map((ClassModel cls) {
                            return DropdownMenuItem(
                              value: cls.name,
                              child: Text(cls.name),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              applicant.class_name = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select the class';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                          onSaved: (newValue) =>
                              applicant.last_name = newValue!,
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("Gender"),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: applicant.gender == 'Female'
                                    ? Colors.purple
                                    : Colors.grey.shade200,
                              ),
                              onPressed: () {
                                setState(() {
                                  applicant.gender = 'Female';
                                });
                              },
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.venus,
                                    color: applicant.gender == 'Female'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Female',
                                    style: TextStyle(
                                        color: applicant.gender == 'Female'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: applicant.gender == 'Male'
                                    ? Colors.purple
                                    : Colors.grey.shade200,
                              ),
                              onPressed: () {
                                setState(() {
                                  applicant.gender = 'Male';
                                });
                              },
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.mars,
                                    color: applicant.gender == 'Male'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Male',
                                    style: TextStyle(
                                        color: applicant.gender == 'Male'
                                            ? Colors.white
                                            : Colors.black),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputDatePickerFormField(
                          initialDate: applicant.dob ??
                              DateTime.now()
                                  .subtract(const Duration(days: 365 * 4)),
                          onDateSaved: (value) {
                            applicant.dob = value;
                          },
                          errorInvalidText:
                              'Child must be between 4 and 20 years old',
                          fieldLabelText: 'Date of Birth',
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365 * 20)),
                          lastDate: DateTime.now()
                              .subtract(const Duration(days: 365 * 4)),
                        ),
                        // CalendarDatePicker2(
                        //   config: CalendarDatePicker2Config(),
                        //   value: dob,
                        //   onValueChanged: (dates) => applicant.dob = dob[0],
                        // ),
                        DropdownButtonFormField(
                          value: applicant.category,
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
                            value: applicant.religion_id,
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
                        Row(
                          children: [
                            const Text('Is Catholic'),
                            const SizedBox(
                              width: 20,
                            ),
                            Switch(
                              inactiveThumbColor: Colors.redAccent,
                              inactiveTrackColor: Colors.red.shade50,
                              activeColor: Colors.greenAccent,
                              activeTrackColor: Colors.green.shade50,
                              value:
                                  applicant.is_catholic == 'Y' ? true : false,
                              onChanged: (bool newValue) {
                                setState(() {
                                  applicant.is_catholic =
                                      newValue == true ? 'Y' : 'N';
                                });
                              },
                            ),
                          ],
                        ),
                        applicant.is_catholic == 'Y'
                            ? TextFormField(
                                onSaved: (newValue) {
                                  applicant.balang = newValue!;
                                },
                                initialValue: applicant.balang,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  labelText: 'Balang',
                                  border: OutlineInputBorder(),
                                ),
                              )
                            : const SizedBox(),
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
            ),
    );
  }

  void saveData() {
    String url = '';
    if (Platform.isAndroid) {
      if (applicantID == null) {
        url = 'http://10.0.2.2:8000/api/admission/personal';
      } else {
        url = 'http://10.0.2.2:8000/api/admission/updatepersonal/$applicantID';
      }
    } else {
      if (applicantID == null) {
        url = 'http://localhost:8000/api/admission/personal';
      } else {
        url = 'http://localhost:8000/api/admission/updatepersonal/$applicantID';
      }
    }

    var data = {
      'admission_user_id': '11',
      'first_name': applicant.first_name,
      'last_name': applicant.last_name,
      'middle_name': applicant.middle_name,
      'category': applicant.category,
      'gender': applicant.gender,
      'dob': applicant.dob.toString(),
      'state': 'Meghalya',
      'nationality': 'Meghalya',
      'religion_id': applicant.religion_id.toString(),
      'language': 'Meghalya',
      'community': 'Meghalya',
      'is_catholic': applicant.is_catholic,
      'balang': applicant.balang,
      'class_name': applicant.class_name,
    };
    if (applicantID == null) {
      http.post(Uri.parse(url), body: data, headers: {
        'Accept': 'application/json',
        // 'Content-Type': 'application/json'
      }).then((response) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      });
    } else {
      http.put(Uri.parse(url), body: data, headers: {
        'Accept': 'application/json',
        // 'Content-Type': 'application/json'
      }).then((response) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      });
    }
    Navigator.pushNamed(context, '/admissionfamily');
  }
}
