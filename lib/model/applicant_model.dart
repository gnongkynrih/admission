import 'dart:convert';

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
    this.is_catholic = 'N',
    this.balang = '',
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
      uuid: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      middle_name: json['middle_name'],
      class_name: json['class_name'],
      passport: json['passport'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'first_name': first_name,
      'last_name': last_name,
      'middle_name': middle_name,
      'mobile': mobile,
      'email': email,
      'father_name': father_name,
      'mother_name': mother_name,
      'category': category,
      'gender': gender,
      'class_name': class_name,
      'dob': dob?.millisecondsSinceEpoch,
      'address': address,
      'state': state,
      'passport': passport,
      'nationality': nationality,
      'community': community,
      'religion_id': religion_id,
      'is_catholic': is_catholic,
      'balang': balang,
      'admission_user_id': admission_user_id,
      'address_proof': address_proof,
      'birth_certificate': birth_certificate,
      'caste_certificate': caste_certificate,
      'baptism_certificate': baptism_certificate,
      'language': language,
      'father_occupation': father_occupation,
      'mother_occupation': mother_occupation,
      'father_phone': father_phone,
      'mother_phone': mother_phone,
      'corresponding_address': corresponding_address,
      'permanent_address': permanent_address,
      'father_designation': father_designation,
      'mother_designation': mother_designation,
      'guardian_name': guardian_name,
      'guardian_address': guardian_address,
      'guardian_phone': guardian_phone,
      'father_id': father_id,
      'mother_id': mother_id,
      'boys': boys,
      'girls': girls,
      'total_members': total_members,
      'family_pic': family_pic,
      'created_at': created_at?.millisecondsSinceEpoch,
    };
  }

  factory ApplicantModel.fromMap(Map<String, dynamic> map) {
    return ApplicantModel(
      uuid: map['uuid'] ?? '', //if map[uuid] is not null then
      //assign it to uuid else assign empty string

      first_name: map['first_name'] ?? '',
      last_name: map['last_name'] ?? '',
      middle_name: map['middle_name'] ?? '',
      //rest do the same

      mobile: map['mobile'] != null ? map['mobile'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      father_name:
          map['father_name'] != null ? map['father_name'] as String : null,
      mother_name:
          map['mother_name'] != null ? map['mother_name'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      class_name:
          map['class_name'] != null ? map['class_name'] as String : null,
      dob: map['dob'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dob'] as int)
          : null,
      address: map['address'] != null ? map['address'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      passport: map['passport'] != null ? map['passport'] as String : null,
      nationality:
          map['nationality'] != null ? map['nationality'] as String : null,
      community: map['community'] != null ? map['community'] as String : null,
      religion_id:
          map['religion_id'] != null ? map['religion_id'] as int : null,
      is_catholic:
          map['is_catholic'] != null ? map['is_catholic'] as String : null,
      balang: map['balang'] != null ? map['balang'] as String : null,
      admission_user_id: map['admission_user_id'] != null
          ? map['admission_user_id'] as int
          : null,
      address_proof:
          map['address_proof'] != null ? map['address_proof'] as String : null,
      birth_certificate: map['birth_certificate'] != null
          ? map['birth_certificate'] as String
          : null,
      caste_certificate: map['caste_certificate'] != null
          ? map['caste_certificate'] as String
          : null,
      baptism_certificate: map['baptism_certificate'] != null
          ? map['baptism_certificate'] as String
          : null,
      language: map['language'] != null ? map['language'] as String : null,
      father_occupation: map['father_occupation'] != null
          ? map['father_occupation'] as String
          : null,
      mother_occupation: map['mother_occupation'] != null
          ? map['mother_occupation'] as String
          : null,
      father_phone:
          map['father_phone'] != null ? map['father_phone'] as String : null,
      mother_phone:
          map['mother_phone'] != null ? map['mother_phone'] as String : null,
      corresponding_address: map['corresponding_address'] != null
          ? map['corresponding_address'] as String
          : null,
      permanent_address: map['permanent_address'] != null
          ? map['permanent_address'] as String
          : null,
      father_designation: map['father_designation'] != null
          ? map['father_designation'] as String
          : null,
      mother_designation: map['mother_designation'] != null
          ? map['mother_designation'] as String
          : null,
      guardian_name:
          map['guardian_name'] != null ? map['guardian_name'] as String : null,
      guardian_address: map['guardian_address'] != null
          ? map['guardian_address'] as String
          : null,
      guardian_phone: map['guardian_phone'] != null
          ? map['guardian_phone'] as String
          : null,
      father_id: map['father_id'] != null ? map['father_id'] as String : null,
      mother_id: map['mother_id'] != null ? map['mother_id'] as String : null,
      boys: map['boys'] != null ? map['boys'] as int : null,
      girls: map['girls'] != null ? map['girls'] as int : null,
      total_members:
          map['total_members'] != null ? map['total_members'] as int : null,
      family_pic:
          map['family_pic'] != null ? map['family_pic'] as String : null,
      created_at: map['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApplicantModel.fromJson(String source) =>
      ApplicantModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
