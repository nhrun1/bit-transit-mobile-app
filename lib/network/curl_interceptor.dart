import 'dart:convert';
import 'package:bit_transit/helpers/app_logger.dart';
import 'package:bit_transit/network/curl_formatter.dart';
import 'package:dio/dio.dart';

class CurlLoggerDioInterceptor extends Interceptor {
  final bool? printOnSuccess;
  final bool convertFormData;

  CurlLoggerDioInterceptor({this.printOnSuccess, this.convertFormData = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log CURL for all requests
    _renderCurlRepresentation(
      options,
      isError: false,
    );
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log successful responses if printOnSuccess is true
    if (printOnSuccess == true) {
      _renderCurlRepresentation(
        response.requestOptions,
        isError: false,
        response: response,
      );
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _renderCurlRepresentation(
      err.requestOptions,
      isError: true,
      err: err,
    );

    return handler.next(err);
  }

  void _renderCurlRepresentation(
    RequestOptions requestOptions, {
    bool isError = false,
    DioException? err,
    Response? response,
  }) {
    try {
      final logSafeCurl = requestOptions.toLogSafeCurl();
      final executableCurl = requestOptions.toExecutableCurl();
      
      if (isError == true && err != null) {
        AppLogger.e(
          "🔴 API ERROR\n"
          "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
          "Error: ${err.message}\n"
          "Status: ${err.response?.statusCode}\n"
          "Response Body:\n${_prettyResponse(err.response?.data)}\n\n"
          "🔄 CURL (Safe for logs):\n$logSafeCurl\n\n"
          "📋 CURL (Copy to Postman/Terminal):\n$executableCurl\n"
          "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
          preview: "🔴 API FAILED: ${requestOptions.method} ${requestOptions.path}",
        );
      } else if (response != null) {
        AppLogger.log(
          "🟢 API SUCCESS\n"
          "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
          "Status: ${response.statusCode}\n"
          "Response Body:\n${_prettyResponse(response.data)}\n\n"
          "🔄 CURL (Safe for logs):\n$logSafeCurl\n\n"
          "📋 CURL (Copy to Postman/Terminal):\n$executableCurl\n"
          "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
          preview: "🟢 API SUCCESS: ${requestOptions.method} ${requestOptions.path}",
        );
      } else {
        // Just log the CURL command for outgoing requests
        AppLogger.log(
          "📤 API REQUEST\n"
          "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
          "🔄 CURL (Safe for logs):\n$logSafeCurl\n\n"
          "📋 CURL (Copy to Postman/Terminal):\n$executableCurl\n"
          "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
          preview: "📤 API REQUEST: ${requestOptions.method} ${requestOptions.path}",
        );
      }
    } catch (error) {
      AppLogger.e(
        "",
        preview: '❌ Unable to create CURL representation: $error',
      );
    }
  }

}

String _prettyResponse(dynamic data) {
  if (data == null) return 'null';
  
  if (data is Map) {
    return prettyJson(data as Map<String, dynamic>);
  }
  
  if (data is List) {
    try {
      final encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  return data.toString();
}

String prettyJson(Map<String, dynamic> json) {
  try {
    const indent = '  ';
    final encoder = JsonEncoder.withIndent(indent);
    return encoder.convert(json);
  } catch (e) {
    return json.toString();
  }
}
