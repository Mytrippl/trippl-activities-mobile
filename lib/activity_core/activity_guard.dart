import '../trippl_activities_mobile.dart';

class ActivityGuard {
  static void record(List<ActivityIssue> issues) {
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
  }

  static String identity(String value) {
    if (value.trim() != value ||
        value.isEmpty ||
        value.length > 200 ||
        RegExp(r'[\x00-\x1f]').hasMatch(value))
      throw const FormatException('Invalid activity identity');
    return value;
  }

  static void revision(int actual, int expected) {
    if (actual != expected) throw StateError('Activity state revision changed');
  }

  static void distinct(Iterable<String> values) {
    final seen = <String>{};
    for (final v in values) {
      identity(v);
      if (!seen.add(v))
        throw const FormatException('Activity identities repeat');
    }
  }

  static bool fresh(DateTime? observed, DateTime? expires, DateTime now) =>
      observed != null &&
      expires != null &&
      !observed.isAfter(now) &&
      expires.isAfter(now);
  static void product(ActivityProduct value, {DateTime? now}) {
    record(value.validate());
    identity(value.id);
    if (now != null && value.observedAt?.isAfter(now) == true)
      throw const FormatException('Activity observation is in the future');
    for (final o in value.options) identity(o.id);
    distinct(value.photos.map((p) => p.id));
    distinct(value.reviews.map((r) => r.id));
  }

  static Uri https(String text) {
    final uri = Uri.tryParse(text);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.queryParameters.keys.any(
          (k) => {
            'key',
            'api_key',
            'apikey',
            'token',
            'access_token',
          }.contains(k.toLowerCase()),
        ))
      throw const FormatException('Use a credential-free HTTPS resource');
    return uri;
  }

  static Object? inspect(
    Object? value, {
    int depth = 0,
    Set<Object>? ancestors,
  }) {
    if (depth > 12)
      throw const FormatException('Activity input nesting exceeds limit');
    if (value == null || value is bool || value is int) return value;
    if (value is double) {
      if (!value.isFinite)
        throw const FormatException('Activity number must be finite');
      return value;
    }
    if (value is String) {
      if (value.length > 100000)
        throw const FormatException('Activity text exceeds limit');
      return value;
    }
    final visited = ancestors ?? Set<Object>.identity();
    if (!visited.add(value))
      throw const FormatException('Activity input contains a cycle');
    try {
      if (value is List) {
        if (value.length > 1000)
          throw const FormatException('Activity list exceeds limit');
        return [
          for (final v in value)
            inspect(v, depth: depth + 1, ancestors: visited),
        ];
      }
      if (value is Map) {
        if (value.length > 100 || value.keys.any((k) => k is! String))
          throw const FormatException('Activity object keys are invalid');
        return {
          for (final e in value.entries)
            e.key as String: inspect(
              e.value,
              depth: depth + 1,
              ancestors: visited,
            ),
        };
      }
      throw const FormatException('Unsupported activity input type');
    } finally {
      visited.remove(value);
    }
  }

  static Map<String, Object?> object(Object? value) =>
      ActivityCodec.object(inspect(value));
  static DateTime day(DateTime value) =>
      DateTime.utc(value.year, value.month, value.day);
  static void canonicalDay(DateTime value) {
    if (!value.isUtc ||
        value.hour != 0 ||
        value.minute != 0 ||
        value.second != 0 ||
        value.millisecond != 0 ||
        value.microsecond != 0)
      throw const FormatException('Use a UTC date-only activity date');
  }

  static void language(String language) {
    if (!RegExp(r'^[a-z]{2,3}(?:-[A-Za-z]{2,4})?$').hasMatch(language))
      throw const FormatException('Invalid activity language code');
  }
}
