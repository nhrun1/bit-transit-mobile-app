import 'dart:convert';
import 'package:dio/dio.dart';

class CurlFormatter {
  static String toCurl(RequestOptions options, {bool maskSensitiveData = true}) {
    final components = <String>['curl'];
    
    components.add('-L');
    
    if (options.method.toUpperCase() != 'GET') {
      components.add('-X ${options.method.toUpperCase()}');
    }

    _addHeaders(components, options.headers, maskSensitive: maskSensitiveData);
    
    _addRequestBody(components, options.data);
    
    components.add('"${options.uri.toString()}"');
    
    return _formatCommand(components);
  }
  
  static void _addHeaders(List<String> components, Map<String, dynamic> headers, {bool maskSensitive = true}) {
    headers.forEach((key, value) {
      if (_shouldIncludeHeader(key)) {
        String headerValue = value.toString();
        
        if (maskSensitive && _isSensitiveHeader(key)) {
          headerValue = _maskSensitiveValue(key, headerValue);
        }
        
        components.add('-H "$key: $headerValue"');
      }
    });
  }
  
  static void _addRequestBody(List<String> components, dynamic data) {
    if (data == null) return;
    
    try {
      String bodyString;
      String contentType = 'application/json';
      
      if (data is FormData) {
        final formPairs = <String>[];
        for (final field in data.fields) {
          final key = Uri.encodeComponent(field.key);
          final value = Uri.encodeComponent(field.value);
          formPairs.add('$key=$value');
        }
        bodyString = formPairs.join('&');
        contentType = 'application/x-www-form-urlencoded';
        
        bool hasContentType = false;
        for (final component in components) {
          if (component.contains('Content-Type')) {
            hasContentType = true;
            break;
          }
        }
        if (!hasContentType) {
          components.add('-H "Content-Type: $contentType"');
        }
      } else if (data is Map || data is List) {
        bodyString = json.encode(data);
      } else {
        bodyString = data.toString();
      }
      
      components.add("-d '$bodyString'");
      
    } catch (e) {
      components.add('-d "Error serializing request body: $e"');
    }
  }
  
  static String _formatCommand(List<String> components) {
    if (components.length <= 3) {
      return components.join(' ');
    }
    
    final buffer = StringBuffer();
    buffer.write(components.first);
    
    for (int i = 1; i < components.length; i++) {
      buffer.write(' \\\n  ');
      buffer.write(components[i]);
    }
    
    return buffer.toString();
  }
  
  static bool _shouldIncludeHeader(String headerName) {
    final excludedHeaders = {'cookie', 'user-agent'};
    return !excludedHeaders.contains(headerName.toLowerCase());
  }
  
  static bool _isSensitiveHeader(String headerName) {
    final sensitiveHeaders = {'authorization', 'x-api-key', 'x-auth-token'};
    return sensitiveHeaders.contains(headerName.toLowerCase());
  }
  
  static String _maskSensitiveValue(String headerName, String value) {
    if (headerName.toLowerCase() == 'authorization') {
      if (value.toLowerCase().startsWith('bearer ')) {
        return 'Bearer ***MASKED***';
      } else if (value.toLowerCase().startsWith('basic ')) {
        return 'Basic ***MASKED***';
      }
    }
    return '***MASKED***';
  }
  
  static String toPostmanCurl(RequestOptions options) {
    final components = <String>['curl'];
    
    if (options.method.toUpperCase() != 'GET') {
      components.add('--request ${options.method.toUpperCase()}');
    }
    
    components.add('--url "${options.uri.toString()}"');
    
    options.headers.forEach((key, value) {
      if (_shouldIncludeHeader(key)) {
        components.add('--header "$key: $value"');
      }
    });
    
    if (options.data != null) {
      try {
        String bodyString;
        if (options.data is FormData) {
          final fields = <String, dynamic>{};
          for (final field in (options.data as FormData).fields) {
            fields[field.key] = field.value;
          }
          bodyString = json.encode(fields);
        } else {
          bodyString = json.encode(options.data);
        }
        components.add("--data '$bodyString'");
      } catch (e) {
        components.add('--data "Error serializing data"');
      }
    }
    
    return components.join(' ');
  }
}

extension RequestOptionsCurl on RequestOptions {
  String toCurl({bool maskSensitiveData = true}) {
    return CurlFormatter.toCurl(this, maskSensitiveData: maskSensitiveData);
  }
  
  String toExecutableCurl() {
    return CurlFormatter.toCurl(this, maskSensitiveData: false);
  }
  
  String toLogSafeCurl() {
    return CurlFormatter.toCurl(this, maskSensitiveData: true);
  }
  
  String toPostmanCurl() {
    return CurlFormatter.toPostmanCurl(this);
  }
}