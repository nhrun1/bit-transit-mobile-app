import 'package:bit_transit/constants/constants.dart';
import 'package:bit_transit/helpers/app_logger.dart';
import 'package:bit_transit/network/curl_interceptor.dart';
import 'package:bit_transit/network/header_token_interceptor.dart';
import 'package:bit_transit/network/loading_interceptor.dart';
import 'package:bit_transit/network/logger_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BitTransitAppDio with DioMixin implements Dio {
  static Dio getInstance({
    BaseOptions? options,
    bool needAccessToken = true,
    bool renewAccessToken = false,
    bool hasDefaultHeader = true,
    bool activeSessionController = true,
    String? baseUrl,
    bool needXUser = false,
  }) {
    return BitTransitAppDio._(
      options: options,
      needAccessToken: needAccessToken,
      renewAccessToken: renewAccessToken,
      baseUrl: baseUrl,
      hasDefaultHeader: hasDefaultHeader,
      activeSessionController: activeSessionController,
      needXUser: needXUser,
    );
  }

  BitTransitAppDio._({
    BaseOptions? options,
    required bool needAccessToken,
    required bool renewAccessToken,
    required bool hasDefaultHeader,
    String? baseUrl,
    required bool activeSessionController,
    required bool needXUser,
  }) {
    final optionsX = options ??
        BaseOptions(
          baseUrl: baseUrl ?? Constants.instance.baseUrl,
          contentType: 'application/json',
          connectTimeout: const Duration(seconds: Constants.defaultConnectTimeout),
          sendTimeout: const Duration(seconds: Constants.defaultConnectTimeout),
          receiveTimeout: const Duration(seconds: Constants.defaultConnectTimeout),
          persistentConnection: false,
        );
    httpClientAdapter = HttpClientAdapter();

    this.options = optionsX;

    // / Loading xử lý đầu tiên
    interceptors.addAll(
      [
        CurlLoggerDioInterceptor(printOnSuccess: true, convertFormData: true),
        LoadingInterceptor(),
        // ConnectionInterceptor(),
      ],
    );

    if (hasDefaultHeader) {
      interceptors.add(
        HeaderInterceptor(),
      );
    }
    interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        if (needAccessToken) {
          try {
            final sharedPreferences = await SharedPreferences.getInstance();
            final accessToken = sharedPreferences.getString(Constants.accessToken);
            if (accessToken != null) {
              options.headers.addAll({
                "Authorization": "Bearer $accessToken",
              });
            }
          } catch (e) {
            AppLogger.e("", preview: e);
          }
        }
        if (needXUser) {
          final sharedPreferences = await SharedPreferences.getInstance();
          final userId = sharedPreferences.getString(Constants.userId);
          if (userId != null) {
            options.headers.addAll({
              "x-user": userId,
            });
          }
        }

        return handler.next(options);
      },
      onResponse: (response, handler) async {
        if (renewAccessToken) {
          try {
            final sharedPreferences = await SharedPreferences.getInstance();
            final accessToken = response.data['data']['accessToken'];
            if (accessToken != null && accessToken != "") {
              await sharedPreferences.setString(Constants.accessToken, "$accessToken");
            }
            final refreshToken = response.data['data']['refreshToken'];
            if (refreshToken != null && refreshToken != "") {
              await sharedPreferences.setString(Constants.refreshToken, refreshToken);
            }
            // QueueManager.shared.setCancelStatus(false);
          } catch (e) {
            AppLogger.e("", preview: e);
          }
        }

        return handler.next(response);
      },
      onError: (error, handler) async {
        // if (activeSessionController && QueueManager.shared.isCancelled == false && error.response?.statusCode == 401) {
        //   final sharedPreferences = await SharedPreferences.getInstance();
        //   await sharedPreferences.remove(Constants.accessToken);
        //   // Modular.get<MetaMaskAuthBloc>().add(MetamaskReleaseEvent());
        //   // Modular.get<RaceDetailsCubit>().release();
        //   // Modular.get<GStartingSoonCubit>().release();
        //   // Modular.get<HStartingSoonCubit>().release();
        //   // Modular.get<AllRacingCubit>().release();
        //   // Modular.get<GLiveCubit>().release();
        //   // Modular.get<BetCubit>().release();
        //   // QueueManager.shared.setCancelStatus(true);
        //   await AppDialog(
        //     uuid: Uuid().v4(),
        //     showCloseIcon: false,
        //     debugLabel: "SessionTimeOutDialog",
        //     child: SessionTimeOutDialog(),
        //   ).show();
        //   return handler.reject(error);
        // }

        // if (error.response?.statusCode == 426) {
        //   final sharedPreferences = await SharedPreferences.getInstance();
        //   await sharedPreferences.remove(Constants.accessToken);
        //   Modular.get<MetaMaskAuthBloc>().add(MetamaskReleaseEvent());
        //   Modular.get<RaceDetailsCubit>().release();
        //   Modular.get<GStartingSoonCubit>().release();
        //   Modular.get<HStartingSoonCubit>().release();
        //   Modular.get<AllRacingCubit>().release();
        //   // Modular.get<GLiveCubit>().release();
        //   Modular.get<BetCubit>().release();
        //   await AppDialog(
        //     uuid: Uuid().v4(),
        //     showCloseIcon: false,
        //     debugLabel: "ForceUpdateDialog",
        //     child: ForceUpdateDialog(),
        //   ).show();
        //   return handler.reject(error);
        // }
        // if (error.type == DioExceptionType.connectionTimeout ||
        //     error.type == DioExceptionType.receiveTimeout ||
        //     error.type == DioExceptionType.sendTimeout ||
        //     error.type == DioExceptionType.connectionError && QueueManager.shared.isCancelled == false) {
        //   QueueManager.shared.setCancelStatus(true);
        //   await AppDialog(
        //     uuid: Uuid().v4(),
        //     showCloseIcon: false,
        //     debugLabel: "RequestTimeoutDialog",
        //     child: RequestTimeoutDialog(),
        //   ).show();
        // }
        //
        // return handler.next(error);
        return handler.next(error);
      },
    ));

    interceptors.addAll(
      [
        // CurlLoggerDioInterceptor(), // Removed duplicate, already added at the beginning
        LoggerDioInterceptor(),
      ],
    );
  }
}
