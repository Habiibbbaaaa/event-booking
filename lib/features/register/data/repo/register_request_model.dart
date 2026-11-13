class RegisterRequestModel {
  String email;
  String password;

  RegisterRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
  //هاخد فيه الداتا الي اليوزر هيبعتها 