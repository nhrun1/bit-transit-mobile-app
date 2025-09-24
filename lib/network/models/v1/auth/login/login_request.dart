import 'dart:convert';

class LoginRequest {
  final String? email;
  final String? password;
  final String? userName;
  final String? language;

  LoginRequest({
    this.email,
    this.password,
    this.userName,
    this.language,
  });

  factory LoginRequest.fromRawJson(String str) =>
      LoginRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    email: json["email"],
    password: json["password"],
    userName: json["userName"],
    language: json["language"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "userName": userName,
    "language": language,
  };
}
