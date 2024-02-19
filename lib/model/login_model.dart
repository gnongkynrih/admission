class LoginModel {
  late String email;
  late String password;

  LoginModel({required this.email, required this.password});

  //set default value
  factory LoginModel.initial() {
    return LoginModel(email: 'nielit@abc.com', password: 'password');
  }
}
