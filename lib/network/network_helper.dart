// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bit_transit/helpers/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';


class BaseResponse<T> {
  final int code;
  final String? message;
  final T? data;
  BaseResponse({
    required this.code,
    this.message,
    this.data,
  });

  bool get isSuccess => code == 2000;
}

Future<BaseResponse<T>> runAsync<T>(
  Future<HttpResponse<T>> apiFunction, {
  required T Function(Map<String, dynamic> json)? fromJson,
}) async {
  try {
    final response = await apiFunction;
    final x = fromJson?.call(response.response.data);

    return BaseResponse<T>(
      code: response.response.data['code'],
      data: x,
      message: response.response.data['message'],
    );
  } on DioException catch (e) {
    final data = e.response?.data;

    if (data == null) {
      return BaseResponse(
        code: e.response?.statusCode ?? -1,
      );
    } else if (data is Map) {
      final x = fromJson?.call(e.response?.data);
      return BaseResponse(
        code: e.response?.data['code'] ?? -1,
        data: x,
      );
    } else if (data is String) {
      final dataMap = json.decode(data);
      final x = fromJson?.call(dataMap);
      return BaseResponse(
        code: dataMap['code'] ?? -1,
        data: x,
      );
    } else {
      final dataMap = json.decode(data);
      final x = fromJson?.call(dataMap);
      return BaseResponse(
        code: e.response?.statusCode ?? -1,
        data: x,
      );
    }
  } catch (e, s) {
    AppLogger.e("", preview: e);
    AppLogger.e(s);
    return BaseResponse(code: -1);
  }
}

class BlankResponse {
  final int code;
  final String? message;
  BlankResponse({
    required this.code,
    this.message,
  });
  factory BlankResponse.fromRawJson(String str) =>
      BlankResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlankResponse.fromJson(Map<String, dynamic> json) => BlankResponse(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
