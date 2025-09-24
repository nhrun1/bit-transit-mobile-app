import 'dart:convert';

extension MapExt on Map {
  Map<String, dynamic> toStringDynamicMap() {
    final result = Map.from(this);

    for (var key in result.keys) {
      if (result[key] is Map) {
        result[key] = (result[key] as Map).toStringDynamicMap();
      } else if (result[key] is List) {
        final value = [...result[key]];

        for (var i = 0; i < value.length; i++) {
          if (value[i] is Map) {
            value[i] = (value[i] as Map).toStringDynamicMap();
          }
        }
        result[key] = value;
      }
    }

    return Map<String, dynamic>.from(result);
  }

  T? getValue<T>(String value) {
    try {
      return this[value] as T?;
    } catch (e) {
      return null;
    }
  }

  T? getValueOrCreate<T>(
      String key, {
        T? defaultValue,
      }) {
    try {
      final value = getValue<T>(key);
      if (value == null) {
        T? result;
        result = T == Map ? defaultValue ?? ({} as T) : defaultValue;
        this[key] = result;

        return result;
      }
      return value;
    } catch (e) {
      return null;
    }
  }
}

dynamic jsonDecodeSafeCast(
    String source, {
      Object? Function(Object? key, Object? value)? reviver,
    }) {
  try {
    return json.decode(
      source,
      reviver: reviver,
    );
  } catch (e) {
    return null;
  }
}
