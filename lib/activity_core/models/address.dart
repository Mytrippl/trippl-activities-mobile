// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityAddress {
  ActivityAddress({
    this.formatted,
    this.locality,
    this.region,
    this.countryCode,
    this.postalCode,
    this.line1,
    this.language,
  });

  final String? formatted;
  final String? locality;
  final String? region;
  final String? countryCode;
  final String? postalCode;
  final String? line1;
  final String? language;

  factory ActivityAddress.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "formatted",
      "locality",
      "region",
      "countryCode",
      "postalCode",
      "line1",
      "language",
    });
    final value = ActivityAddress(
      formatted: ActivityCodec.text(json, 'formatted'),
      locality: ActivityCodec.text(json, 'locality'),
      region: ActivityCodec.text(json, 'region'),
      countryCode: ActivityCodec.text(json, 'countryCode'),
      postalCode: ActivityCodec.text(json, 'postalCode'),
      line1: ActivityCodec.text(json, 'line1'),
      language: ActivityCodec.text(json, 'language'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityAddress> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityAddress.fromJson(ActivityCodec.object(input)),
      );
    } on ActivityValidationException catch (e) {
      return ActivityResult(issues: e.issues);
    } on FormatException {
      return ActivityResult(
        issues: const [
          ActivityIssue(
            'record',
            'format',
            'Activity record has invalid fields or values',
          ),
        ],
      );
    }
  }

  ActivityAddress copyWith({
    Set<String> clear = const {},
    String? formatted,
    String? locality,
    String? region,
    String? countryCode,
    String? postalCode,
    String? line1,
    String? language,
  }) {
    final clearableFields = <String>{
      "formatted",
      "locality",
      "region",
      "countryCode",
      "postalCode",
      "line1",
      "language",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityAddress(
      formatted: clear.contains('formatted')
          ? null
          : (formatted ?? this.formatted),
      locality: clear.contains('locality') ? null : (locality ?? this.locality),
      region: clear.contains('region') ? null : (region ?? this.region),
      countryCode: clear.contains('countryCode')
          ? null
          : (countryCode ?? this.countryCode),
      postalCode: clear.contains('postalCode')
          ? null
          : (postalCode ?? this.postalCode),
      line1: clear.contains('line1') ? null : (line1 ?? this.line1),
      language: clear.contains('language') ? null : (language ?? this.language),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    if (formatted != null) {
      if (formatted!.trim().isEmpty || formatted!.length > 4000)
        validationIssues.add(
          const ActivityIssue('formatted', 'text', 'Use nonempty bounded text'),
        );
    }
    if (locality != null) {
      if (locality!.trim().isEmpty || locality!.length > 4000)
        validationIssues.add(
          const ActivityIssue('locality', 'text', 'Use nonempty bounded text'),
        );
    }
    if (region != null) {
      if (region!.trim().isEmpty || region!.length > 4000)
        validationIssues.add(
          const ActivityIssue('region', 'text', 'Use nonempty bounded text'),
        );
    }
    if (countryCode != null) {
      if (countryCode!.trim().isEmpty || countryCode!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'countryCode',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (postalCode != null) {
      if (postalCode!.trim().isEmpty || postalCode!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'postalCode',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (line1 != null) {
      if (line1!.trim().isEmpty || line1!.length > 4000)
        validationIssues.add(
          const ActivityIssue('line1', 'text', 'Use nonempty bounded text'),
        );
    }
    if (language != null) {
      if (language!.trim().isEmpty || language!.length > 4000)
        validationIssues.add(
          const ActivityIssue('language', 'text', 'Use nonempty bounded text'),
        );
    }
    if (countryCode != null && !RegExp(r'^[A-Z]{2}$').hasMatch(countryCode!))
      validationIssues.add(
        const ActivityIssue(
          'record',
          'contract',
          'Record violates its domain constraints',
        ),
      );
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    if (formatted != null) "formatted": formatted,
    if (locality != null) "locality": locality,
    if (region != null) "region": region,
    if (countryCode != null) "countryCode": countryCode,
    if (postalCode != null) "postalCode": postalCode,
    if (line1 != null) "line1": line1,
    if (language != null) "language": language,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityAddress && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityAddress(redacted)';
}
