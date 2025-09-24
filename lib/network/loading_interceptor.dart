import 'package:bit_transit/common/design/loading/loading_manager.dart';
import 'package:bit_transit/constants/constants.dart';
import 'package:bit_transit/helpers/app_logger.dart';
import 'package:dio/dio.dart';

class LoadingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final String loadingTag = "API: ${options.method} ${options.path}";
      final isShowLoading = options.headers[Constants.isShowLoading] ?? true;

      if (isShowLoading) {
        LoadingManager.shared.show(tag: loadingTag);
      }
      super.onRequest(options, handler);
    } catch (e) {
      AppLogger.e(
        "onRequest: ${options.method} - ${options.uri}",
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      final String loadingTag =
          "API: ${err.requestOptions.method} ${err.requestOptions.path}";
      final isShowLoading =
          err.requestOptions.headers[Constants.isShowLoading] ?? true;

      if (isShowLoading) {
        LoadingManager.shared.hide(tag: loadingTag);
      }
      super.onError(err, handler);
    } catch (e) {
      AppLogger.e(
        "onError: ${err.requestOptions.method} - ${err.requestOptions.uri}",
      );
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      final String loadingTag =
          "API: ${response.requestOptions.method} ${response.requestOptions.path}";
      final isShowLoading =
          response.requestOptions.headers[Constants.isShowLoading] ?? true;

      if (isShowLoading) {
        LoadingManager.shared.hide(tag: loadingTag);
      }
      super.onResponse(response, handler);
    } catch (e) {
      AppLogger.e(
        "onResponse: ${response.requestOptions.method} - ${response.requestOptions.uri}",
      );
    }
  }
}
