import '../trippl_activities_mobile.dart';

class ActivityDetails {
  static String duration(ActivityDuration? value, {String locale = 'en'}) {
    final tr = locale.startsWith('tr');
    if (value == null) return tr ? 'Süre bilinmiyor' : 'Duration unknown';
    ActivityGuard.record(value.validate());
    String minutes(int value) {
      final h = value ~/ 60, m = value % 60;
      return [
        if (h > 0) '$h ${tr ? 'saat' : 'h'}',
        if (m > 0) '$m ${tr ? 'dk' : 'min'}',
      ].join(' ');
    }

    if (value.fixedMinutes != null)
      return '${minutes(value.fixedMinutes!)}${value.approximate ? ' (${tr ? 'yaklaşık' : 'approx.'})' : ''}';
    if (value.minimumMinutes != null && value.maximumMinutes != null)
      return '${minutes(value.minimumMinutes!)}–${minutes(value.maximumMinutes!)}';
    return tr ? 'Süre değişken' : 'Duration varies';
  }

  static String normalizeLanguage(String value) {
    final parts = value.trim().replaceAll('_', '-').split('-');
    if (parts.isEmpty) throw const FormatException('Empty guide language');
    final language = [
      parts.first.toLowerCase(),
      for (final part in parts.skip(1))
        part.length == 2 ? part.toUpperCase() : part,
    ].join('-');
    ActivityGuard.language(language);
    return language;
  }

  static List<ActivityGuideLanguage> languages(
    ActivityOption option, {
    String? kind,
  }) {
    ActivityGuard.record(option.validate());
    if (kind != null && !{'guide', 'audio', 'written'}.contains(kind))
      throw const FormatException('Unknown language delivery kind');
    final found = <String, ActivityGuideLanguage>{};
    for (final value in option.languages.where(
      (l) => l.available && (kind == null || l.kind == kind),
    )) {
      final key = '${value.kind}:${value.code}';
      if (found[key] != null && found[key] != value)
        throw const FormatException('Guide language definitions conflict');
      found[key] = value;
    }
    final keys = found.keys.toList()..sort();
    return List.unmodifiable(keys.map((k) => found[k]!));
  }

  static List<ActivityPhoto> photos(
    ActivityProduct product, {
    required DateTime now,
    int maximum = 5,
  }) {
    ActivityGuard.product(product);
    if (maximum < 0 || maximum > 20)
      throw const FormatException('Invalid activity photo limit');
    ActivityGuard.distinct(product.photos.map((p) => p.id));
    final rows = product.photos
        .where(
          (p) =>
              p.observedAt?.isAfter(now) != true &&
              (p.expiresAt == null || p.expiresAt!.isAfter(now)),
        )
        .toList();
    for (final p in rows) secureUri(p.url);
    rows.sort((a, b) {
      final c = ((b.width ?? 0) * (b.height ?? 0)).compareTo(
        (a.width ?? 0) * (a.height ?? 0),
      );
      return c == 0 ? a.id.compareTo(b.id) : c;
    });
    return List.unmodifiable(rows.take(maximum));
  }

  static Uri secureUri(String text) {
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
      throw const FormatException('Use credential-free HTTPS activity links');
    return uri;
  }

  static List<ActivityReview> reviews(
    ActivityProduct product, {
    String? language,
    int maximum = 5,
  }) {
    ActivityGuard.product(product);
    if (maximum < 0 || maximum > 20)
      throw const FormatException('Invalid review limit');
    ActivityGuard.distinct(product.reviews.map((r) => r.id));
    final rows = product.reviews.toList();
    rows.sort((a, b) {
      if (language != null &&
          (a.language == language) != (b.language == language))
        return a.language == language ? -1 : 1;
      final x = a.publishedAt, y = b.publishedAt;
      if ((x == null) != (y == null)) return x == null ? 1 : -1;
      final c = x == null ? 0 : y!.compareTo(x);
      return c == 0 ? a.id.compareTo(b.id) : c;
    });
    return List.unmodifiable(rows.take(maximum));
  }

  static List<ActivityAttribution> credits({
    Iterable<ActivityAttribution> provider = const [],
    Iterable<ActivityPhoto> photos = const [],
    Iterable<ActivityReview> reviews = const [],
  }) {
    final values = <String, ActivityAttribution>{};
    for (final a in [
      ...provider,
      for (final p in photos) ...p.attributions,
      for (final r in reviews) ...r.attributions,
    ]) {
      ActivityGuard.record(a.validate());
      if (a.uri != null) secureUri(a.uri!);
      if (values[a.id] != null && values[a.id] != a)
        throw StateError('Activity attribution identity conflicts');
      values[a.id] = a;
    }
    if (values.length > 100)
      throw const FormatException('Activity attribution exceeds limit');
    return List.unmodifiable(values.values);
  }

  static String excerpt(String? text, {int maximumRunes = 240}) {
    if (maximumRunes < 1 ||
        maximumRunes > 2000 ||
        text != null && text.length > 20000)
      throw const FormatException('Invalid review excerpt bounds');
    final clean = (text ?? '')
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final runes = clean.runes.toList();
    return runes.length <= maximumRunes
        ? clean
        : '${String.fromCharCodes(runes.take(maximumRunes))}…';
  }

  static String rating(ActivityRating? value, {String locale = 'en'}) {
    if (value?.value == null)
      return locale.startsWith('tr') ? 'Puan bilinmiyor' : 'Rating unknown';
    ActivityGuard.record(value!.validate());
    return '${value.value!.toStringAsFixed(1)}/5${value.count == null ? '' : ' (${value.count})'}';
  }
}
