import 'package:bit_transit/gen/assets.gen.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum LocalizationSupportedLanguage {
  en("en", "English");

  final String languageCode;
  final String languageName;
  const LocalizationSupportedLanguage(this.languageCode, this.languageName);

  factory LocalizationSupportedLanguage.fromLocale(Locale locale) {
    return LocalizationSupportedLanguage.values
            .firstWhereOrNull((e) => e.languageCode == locale.languageCode) ??
        LocalizationSupportedLanguage.defaultLanguage();
  }

  factory LocalizationSupportedLanguage.defaultLanguage() =>
      LocalizationSupportedLanguage.en;

  Widget getIconImage({
    Key? key,
    AssetBundle? bundle,
    Widget Function(BuildContext, Widget, int?, bool)? frameBuilder,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.high,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    switch (this) {
      case LocalizationSupportedLanguage.en:
        // final CountryZ? country = CountryZ.fromCountryName("United Kingdom");
        return Assets.images.imgEn.image(
          height: height,
          width: width,
          fit: BoxFit.fitHeight,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
          color: color,
          filterQuality: filterQuality,
          colorBlendMode: colorBlendMode,
        );
    }
  }
}
