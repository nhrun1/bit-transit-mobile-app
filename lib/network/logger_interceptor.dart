import 'dart:convert';

import 'package:bit_transit/helpers/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggerDioInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      AppLogger.log('''
      Request Headers:
      ${_prettyResponse(response.requestOptions.headers)}

      --------------------------
      
      
      Response Body:  
      ${_prettyResponse(response.data)}''',
          preview: "Request API success!!!\nUri: ${response.realUri}\n ${kDebugMode ? {
              // _prettyResponse(response.data)
              ""
            } : ""}");
      super.onResponse(response, handler);
    } catch (e) {
      AppLogger.e("", preview: e);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
  }
}

String _prettyResponse(dynamic data) {
  if (data is Map) {
    return prettyJson(data as Map<String, dynamic>);
  }

  return data.toString();
}

String prettyJson(Map<String, dynamic> json) {
  final indent = '  ' * 2;
  final encoder = JsonEncoder.withIndent(indent);

  return encoder.convert(json);
}
