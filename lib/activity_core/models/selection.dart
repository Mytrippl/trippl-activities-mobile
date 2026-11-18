// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivitySelection {
  ActivitySelection({
    required this.productId,
    this.optionId,
    this.slotId,
    this.languageCode,
    this.pickupPointId,
    required this.updatedAt,
    this.revision = 1,
    this.requestFingerprint,
  });

  final String productId;
  final String? optionId;
  final String? slotId;
  final String? languageCode;
  final String? pickupPointId;
  final DateTime updatedAt;
  final int revision;
  final String? requestFingerprint;

  factory ActivitySelection.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "productId",
      "optionId",
      "slotId",
      "languageCode",
      "pickupPointId",
      "updatedAt",
      "revision",
      "requestFingerprint",
    });
    final value = ActivitySelection(
      productId: ActivityCodec.text(json, 'productId', required: true)!,
      optionId: ActivityCodec.text(json, 'optionId'),
      slotId: ActivityCodec.text(json, 'slotId'),
      languageCode: ActivityCodec.text(json, 'languageCode'),
      pickupPointId: ActivityCodec.text(json, 'pickupPointId'),
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      requestFingerprint: ActivityCodec.text(json, 'requestFingerprint'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivitySelection> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivitySelection.fromJson(ActivityCodec.object(input)),
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

  ActivitySelection copyWith({
    Set<String> clear = const {},
    String? productId,
    String? optionId,
    String? slotId,
    String? languageCode,
    String? pickupPointId,
    DateTime? updatedAt,
    int? revision,
    String? requestFingerprint,
  }) {
    final clearableFields = <String>{
      "optionId",
      "slotId",
      "languageCode",
      "pickupPointId",
      "requestFingerprint",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivitySelection(
      productId: (productId ?? this.productId),
      optionId: clear.contains('optionId') ? null : (optionId ?? this.optionId),
      slotId: clear.contains('slotId') ? null : (slotId ?? this.slotId),
      languageCode: clear.contains('languageCode')
          ? null
          : (languageCode ?? this.languageCode),
      pickupPointId: clear.contains('pickupPointId')
          ? null
          : (pickupPointId ?? this.pickupPointId),
      updatedAt: (updatedAt ?? this.updatedAt),
      revision: (revision ?? this.revision),
      requestFingerprint: clear.contains('requestFingerprint')
          ? null
          : (requestFingerprint ?? this.requestFingerprint),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (productId.trim().isEmpty || productId.length > 4000)
        validationIssues.add(
          const ActivityIssue('productId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (optionId != null) {
      if (optionId!.trim().isEmpty || optionId!.length > 4000)
        validationIssues.add(
          const ActivityIssue('optionId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (slotId != null) {
      if (slotId!.trim().isEmpty || slotId!.length > 4000)
        validationIssues.add(
          const ActivityIssue('slotId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (languageCode != null) {
      if (languageCode!.trim().isEmpty || languageCode!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'languageCode',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (pickupPointId != null) {
      if (pickupPointId!.trim().isEmpty || pickupPointId!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'pickupPointId',
            'text',
            'Use nonempty bounded text',
          ),
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
    if (requestFingerprint != null) {
      if (requestFingerprint!.trim().isEmpty ||
          requestFingerprint!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'requestFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (revision < 1 || slotId != null && optionId == null)
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
    "productId": productId,
    if (optionId != null) "optionId": optionId,
    if (slotId != null) "slotId": slotId,
    if (languageCode != null) "languageCode": languageCode,
    if (pickupPointId != null) "pickupPointId": pickupPointId,
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "revision": revision,
    if (requestFingerprint != null) "requestFingerprint": requestFingerprint,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivitySelection &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivitySelection(redacted)';
}
