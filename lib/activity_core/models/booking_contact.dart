// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityBookingContact {
  ActivityBookingContact({
    required this.email,
    this.phone,
    this.givenName,
    this.familyName,
    this.language = "en",
    this.revision = 1,
    required this.updatedAt,
  });

  final String email;
  final String? phone;
  final String? givenName;
  final String? familyName;
  final String language;
  final int revision;
  final DateTime updatedAt;

  factory ActivityBookingContact.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "email",
      "phone",
      "givenName",
      "familyName",
      "language",
      "revision",
      "updatedAt",
    });
    final value = ActivityBookingContact(
      email: ActivityCodec.text(json, 'email', required: true)!,
      phone: ActivityCodec.text(json, 'phone'),
      givenName: ActivityCodec.text(json, 'givenName'),
      familyName: ActivityCodec.text(json, 'familyName'),
      language: ActivityCodec.text(json, 'language') ?? "en",
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityBookingContact> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityBookingContact.fromJson(ActivityCodec.object(input)),
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

  ActivityBookingContact copyWith({
    Set<String> clear = const {},
    String? email,
    String? phone,
    String? givenName,
    String? familyName,
    String? language,
    int? revision,
    DateTime? updatedAt,
  }) {
    final clearableFields = <String>{"phone", "givenName", "familyName"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityBookingContact(
      email: (email ?? this.email),
      phone: clear.contains('phone') ? null : (phone ?? this.phone),
      givenName: clear.contains('givenName')
          ? null
          : (givenName ?? this.givenName),
      familyName: clear.contains('familyName')
          ? null
          : (familyName ?? this.familyName),
      language: (language ?? this.language),
      revision: (revision ?? this.revision),
      updatedAt: (updatedAt ?? this.updatedAt),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (email.trim().isEmpty || email.length > 4000)
        validationIssues.add(
          const ActivityIssue('email', 'text', 'Use nonempty bounded text'),
        );
    }
    if (phone != null) {
      if (phone!.trim().isEmpty || phone!.length > 4000)
        validationIssues.add(
          const ActivityIssue('phone', 'text', 'Use nonempty bounded text'),
        );
    }
    if (givenName != null) {
      if (givenName!.trim().isEmpty || givenName!.length > 4000)
        validationIssues.add(
          const ActivityIssue('givenName', 'text', 'Use nonempty bounded text'),
        );
    }
    if (familyName != null) {
      if (familyName!.trim().isEmpty || familyName!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'familyName',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (language.trim().isEmpty || language.length > 4000)
        validationIssues.add(
          const ActivityIssue('language', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (revision < 0 || revision > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'revision',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (revision < 1 ||
        email.length > 254 ||
        phone != null && phone!.length > 30)
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
    "email": email,
    if (phone != null) "phone": phone,
    if (givenName != null) "givenName": givenName,
    if (familyName != null) "familyName": familyName,
    "language": language,
    "revision": revision,
    "updatedAt": updatedAt.toUtc().toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityBookingContact &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityBookingContact(redacted)';
}
