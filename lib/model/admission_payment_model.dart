// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

class AdmissionPaymentModel {
  int id;
  String r_payment_id;
  String applicant_id;
  String status;
  String amount;
  DateTime created_at;
  AdmissionPaymentModel({
    required this.id,
    required this.r_payment_id,
    required this.applicant_id,
    required this.status,
    required this.amount,
    required this.created_at,
  });

  factory AdmissionPaymentModel.fromJson(Map<String, dynamic> json) {
    return AdmissionPaymentModel(
      id: json['id'],
      r_payment_id: json['r_payment_id'] as String,
      applicant_id: json['applicant_id'] as String,
      status: json['status'] as String,
      amount: json['amount'] as String,
      created_at: DateTime.parse(json['created_at'] as String),
    );
  }
}
