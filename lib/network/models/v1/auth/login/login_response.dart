import 'dart:convert';

class LoginResponse {
  final int? code;
  final String? message;
  final LoginResponseData? data;

  LoginResponse({
    this.code,
    this.message,
    this.data,
  });

  factory LoginResponse.fromRawJson(String str) => LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : LoginResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}

class LoginResponseData {
  final String? accessToken;
  final String? refreshToken;
  final int? exp;

  LoginResponseData({
    this.accessToken,
    this.refreshToken,
    this.exp,
  });

  factory LoginResponseData.fromRawJson(String str) => LoginResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponseData.fromJson(Map<String, dynamic> json) => LoginResponseData(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        exp: json["exp"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "exp": exp,
      };
}
