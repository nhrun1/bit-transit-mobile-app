import 'package:bit_transit/common/color.dart';
import 'package:bit_transit/common/typography.dart';
import 'package:bit_transit/features/app/app_router.dart';
import 'package:bit_transit/features/app/keyboard_dismiss.dart';
import 'package:bit_transit/features/global/localization/cubit/localization_cubit.dart';
import 'package:bit_transit/gen/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class BitTransitApp extends StatefulWidget {
  const BitTransitApp({super.key});

  @override
  State<BitTransitApp> createState() => _BitTransitAppState();
}

class _BitTransitAppState extends State<BitTransitApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocalizationCubit()),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({
    super.key,
  });

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismiss(
      child: Sizer(
        builder: (p0, p1, p2) {
          return Builder(
            builder: (context) {
              final localizationCubit = context.read<LocalizationCubit>();
              final locale = context.select(
                (LocalizationCubit cubit) => cubit.state.locale,
              );

              final themeDataOverride = ThemeData.light().copyWith(
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  },
                ),
                primaryColor: colorAlertBlue,
                datePickerTheme: DatePickerThemeData(
                  backgroundColor: colorGrayWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.px),
                  ),
                  dayStyle: tStyle.body3.Regular.tColor(colorGrayBlack),
                  weekdayStyle: tStyle.body3.Regular.tColor(colorGrayBlack),
                ),
              );

              return OverlaySupport.global(
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  routerConfig: router,
                  theme: themeDataOverride,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    S.delegate,
                  ],
                  supportedLocales: localizationCubit.supportedLocales,
                  locale: locale,
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(1),
                    ),
                    child: ClipRRect(child: child ?? const SizedBox()),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
