import 'package:bit_transit/constants/constants.dart';
import 'package:bit_transit/features/global/localization/localization_supported_language.dart';
import 'package:bit_transit/helpers/app_logger.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'localization_state.dart';
part 'localization_cubit.freezed.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit() : super(const LocalizationState.initial());

  List<Locale> get supportedLocales =>
      LocalizationSupportedLanguage.values.map((e) => Locale.fromSubtags(languageCode: e.languageCode)).toList();

  Future<void> initState() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final currentLanguageCode = sharedPreferences.getString(Constants.currentLanguage);
      if (currentLanguageCode != null) {
        final LocalizationSupportedLanguage locale = LocalizationSupportedLanguage.values.firstWhere(
          (e) => e.languageCode == currentLanguageCode,
          orElse: () => LocalizationSupportedLanguage.en,
        );

        await changeLanguage(locale);
        initializeDateFormatting(state.locale?.languageCode);
      } else {
        final LocalizationSupportedLanguage locale = LocalizationSupportedLanguage.values.firstWhere(
          (e) => e.languageCode == currentLanguageCode,
          orElse: () => LocalizationSupportedLanguage.en,
        );
        await changeLanguage(locale);
        initializeDateFormatting(state.locale?.languageCode);
      }
    } catch (e) {
      //
    }
  }

  Future<void> changeLanguage(LocalizationSupportedLanguage language) async {}

  void syncLocale(
    String languageCode, {
    Function()? onDone,
  }) async {
    emit(state.copyWith(
      locale: Locale.fromSubtags(languageCode: languageCode),
    ));
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(Constants.currentLanguage);
    await sharedPreferences.setString(
      Constants.currentLanguage,
      languageCode,
    );
    AppLogger.log("", preview: "CUONG.DOAN: Sync language: ${state.locale}");

    onDone?.call();
  }

  Future<void> initDeviceInfo() async {
    try {
      PermissionStatus status = await Permission.location.status;
      final sharedPreferences = await SharedPreferences.getInstance();
      if (status.isGranted) {
        final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
        final position = await geolocatorPlatform.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 100,
          ),
        );
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
        String regionCity = "";
        try {
          regionCity = currentTimeZone.split("/").last;
        } catch (e) {
          AppLogger.e("Err currentTimeZone");
        }

        if (placemarks.isNotEmpty) {
          await Future.wait([
            sharedPreferences.setString(Constants.country, placemarks.first.isoCountryCode ?? ""),
            sharedPreferences.setString(Constants.region, regionCity),
            sharedPreferences.setString(Constants.city, regionCity),
          ]);
        }
      } else {
        bool hasPermission = await _requestPermission();

        if (hasPermission) {
          initDeviceInfo();
        }
      }
      AppLogger.log("",
          preview:
              "Init DeviceInfo: { city:${sharedPreferences.getString(Constants.city)}, region:${sharedPreferences.getString(Constants.region)}, country:${sharedPreferences.getString(Constants.country)} }");
    } catch (e) {}
  }

  Future<bool> _requestPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied || status.isRestricted) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      //TODO show all dialog
      // await AppDialog(
      //   uuid: Uuid().v4(),
      //   barrierDismissible: false,
      //   showCloseIcon: false,
      //   debugLabel: "PermissionDialog",
      //   child: PermissionDialog(
      //     permissions: [
      //       Permission.location,
      //     ],
      //   ),
      // ).show<bool>();

      status = await Permission.location.status;

      if (status != PermissionStatus.granted) {
        return await _requestPermission();
      }
    }

    return status.isGranted;
  }

  Future<void> changeLocalLocale(String? languageCode) async {
    emit(state.copyWith(
      locale: Locale.fromSubtags(languageCode: languageCode ?? "en"),
    ));
    initializeDateFormatting(state.locale?.languageCode);
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(Constants.currentLanguage);
    await sharedPreferences.setString(
      Constants.currentLanguage,
      languageCode ?? "en",
    );
    AppLogger.log("", preview: "CUONG.DOAN: Active language: ${state.locale}");
  }
}
