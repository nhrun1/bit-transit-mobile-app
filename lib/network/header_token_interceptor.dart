import 'package:dio/dio.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Uncomment when using location data

class HeaderInterceptor extends Interceptor {
  HeaderInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final String? ip = await NetworkInfo().getWifiIPv6();
    final String timezone = DateTime.now().timeZoneOffset.inHours.toString();
    
    // Get package info for app version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    // Uncomment to use location data
    // final sharedPreferences = await SharedPreferences.getInstance();
    // final String city = sharedPreferences.getString(Constants.city) ?? "";
    // final String region = sharedPreferences.getString(Constants.region) ?? "";
    // final String country = sharedPreferences.getString(Constants.country) ?? "";

    options.headers.addAll({
      "accept": "application/json",
      "Content-Type": "application/json",
      "x-IP": ip,
      "timezone": timezone,
      "X-Client-Type": "mobile",
      "App-Version": "$version-$buildNumber",
      // Uncomment to include location data
      // "city": city,
      // "region": region,
      // "country": country,
    });
    super.onRequest(options, handler);
  }
}
