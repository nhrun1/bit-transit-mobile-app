part of 'localization_cubit.dart';

@freezed
class LocalizationState with _$LocalizationState {
  const factory LocalizationState.initial({
    @Default(null) Locale? locale,
    @Default(false) bool notificationUpdatedLocale,
  }) = _Initial;
}
