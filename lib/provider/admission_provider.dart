import 'package:flutter/material.dart';

class AdmissionProvider with ChangeNotifier {
  int admission_user_id = 0;

  void setAdmissionUserId(int id) {
    admission_user_id = id;
    notifyListeners();
  }
}
