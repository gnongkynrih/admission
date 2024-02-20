// ignore_for_file: public_member_api_docs, sort_constructors_first
class ApplicantModel {
  String? uuid;
  String? first_name;
  String? last_name;
  String? middle_name;
  String? mobile;
  String? email;
  String? father_name;
  String? mother_name;
  String? category;
  String? gender;
  String? class_name;
  DateTime? dob;
  String? address;
  String? state;
  String? passport;
  String? nationality;
  String? community;
  int? religion_id;
  String? is_catholic;
  String? balang;
  int? admission_user_id;
  String? address_proof;
  String? birth_certificate;
  String? caste_certificate;
  String? baptism_certificate;
  String? language;
  String? father_occupation;
  String? mother_occupation;
  String? father_phone;
  String? mother_phone;
  String? corresponding_address;
  String? permanent_address;
  String? father_designation;
  String? mother_designation;
  String? guardian_name;
  String? guardian_address;
  String? guardian_phone;
  String? father_id;
  String? mother_id;
  int? boys;
  int? girls;
  int? total_members;
  String? family_pic;
  DateTime? created_at;

  ApplicantModel({
    this.uuid,
    this.first_name,
    this.last_name,
    this.middle_name,
    this.mobile,
    this.email,
    this.father_name,
    this.mother_name,
    this.category,
    this.gender,
    this.class_name,
    this.dob,
    this.address,
    this.state,
    this.passport,
    this.nationality,
    this.community,
    this.religion_id,
    this.is_catholic,
    this.balang,
    this.admission_user_id,
    this.address_proof,
    this.birth_certificate,
    this.caste_certificate,
    this.baptism_certificate,
    this.language,
    this.father_occupation,
    this.mother_occupation,
    this.father_phone,
    this.mother_phone,
    this.corresponding_address,
    this.permanent_address,
    this.father_designation,
    this.mother_designation,
    this.guardian_name,
    this.guardian_address,
    this.guardian_phone,
    this.father_id,
    this.mother_id,
    this.boys,
    this.girls,
    this.total_members,
    this.family_pic,
    this.created_at,
  });

  //use factory method to get the id, name, class_name and passport
  factory ApplicantModel.fromJsonDashboard(Map<String, dynamic> json) {
    return ApplicantModel(
      uuid: json['uuid'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      middle_name: json['middle_name'],
      class_name: json['class_name'],
      passport: json['passport'],
    );
  }
}
