import 'package:admission/model/applicant_model.dart';
import 'package:flutter/material.dart';

class AdmissionProvider with ChangeNotifier {
  int admission_user_id = 0;
  String? applicantId;
  ApplicantModel? newApplicant;

  void setAdmissionUserId(int id) {
    admission_user_id = id;
    notifyListeners();
  }

  void setApplicantId(String? id) {
    applicantId = id;
    notifyListeners();
  }
}
