import 'package:enum_to_string/enum_to_string.dart';

enum Flavor { dev, production }
class Constants {
  final Flavor flavor;

  Constants({
    required this.flavor,
  });

  static final Constants instance = Constants.of();

  factory Constants.of() {
    final flavor = EnumToString.fromString<Flavor>(
      Flavor.values,
      const String.fromEnvironment("flavor"),
    );
    return Constants(flavor: flavor ?? Flavor.production);
  }

  String get baseUrl {
    return krakenBaseUrl;
  }

  String get krakenBaseUrl {
    switch (flavor) {
      case Flavor.dev:
        return "https://unibit-krakend.dev.sotatek.works";
      case Flavor.production:
        return "https://krakend-dev.unibit.io";
    }
  }

  /// Network Keys
  static const String isShowLoading = "isShowLoading";
  static const String timezone = "timezone";
  static const String city = "city";
  static const String region = "region";
  static const String country = "country";
  static const String accessToken = "accessToken";
  static const String refreshToken = "refreshToken";
  static const int defaultConnectTimeout = 15;


  ///Local Keys
  static const String currentLanguage = "curLanguage";
  static const String savedAccount = "savedAccounts";

  ///User
  static const String userId = "userId";



}