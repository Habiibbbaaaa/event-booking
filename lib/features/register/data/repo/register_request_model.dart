class RegisterRequestModel {
  String username;
  String email;
  String password;
  String name;

  RegisterRequestModel({
    required this.username,
    required this.email,
    required this.password,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'name': name,
      };
}
  //هاخد فيه الداتا الي اليوزر هيبعتها 