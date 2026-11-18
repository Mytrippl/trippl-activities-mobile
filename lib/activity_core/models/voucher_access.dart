// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityVoucherAccess {
  ActivityVoucherAccess({
    required this.voucherId,
    required this.bookingId,
    required this.evaluatedAt,
    required this.allowed,
    List<String> reasonCodes = const [],
    this.offline = false,
    this.requiresProviderVerification = true,
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String voucherId;
  final String bookingId;
  final DateTime evaluatedAt;
  final bool allowed;
  final List<String> reasonCodes;
  final bool offline;
  final bool requiresProviderVerification;

  factory ActivityVoucherAccess.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "voucherId",
      "bookingId",
      "evaluatedAt",
      "allowed",
      "reasonCodes",
      "offline",
      "requiresProviderVerification",
    });
    final value = ActivityVoucherAccess(
      voucherId: ActivityCodec.text(json, 'voucherId', required: true)!,
      bookingId: ActivityCodec.text(json, 'bookingId', required: true)!,
      evaluatedAt: ActivityCodec.date(json, 'evaluatedAt', required: true)!,
      allowed: ActivityCodec.boolean(json, 'allowed', required: true)!,
      reasonCodes:
          ActivityCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      offline: ActivityCodec.boolean(json, 'offline') ?? false,
      requiresProviderVerification:
          ActivityCodec.boolean(json, 'requiresProviderVerification') ?? true,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityVoucherAccess> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityVoucherAccess.fromJson(ActivityCodec.object(input)),
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

  ActivityVoucherAccess copyWith({
    Set<String> clear = const {},
    String? voucherId,
    String? bookingId,
    DateTime? evaluatedAt,
    bool? allowed,
    List<String>? reasonCodes,
    bool? offline,
    bool? requiresProviderVerification,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityVoucherAccess(
      voucherId: (voucherId ?? this.voucherId),
      bookingId: (bookingId ?? this.bookingId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      allowed: (allowed ?? this.allowed),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      offline: (offline ?? this.offline),
      requiresProviderVerification:
          (requiresProviderVerification ?? this.requiresProviderVerification),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (voucherId.trim().isEmpty || voucherId.length > 4000)
        validationIssues.add(
          const ActivityIssue('voucherId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (bookingId.trim().isEmpty || bookingId.length > 4000)
        validationIssues.add(
          const ActivityIssue('bookingId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (reasonCodes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'reasonCodes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (reasonCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'reasonCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "voucherId": voucherId,
    "bookingId": bookingId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "allowed": allowed,
    "reasonCodes": reasonCodes,
    "offline": offline,
    "requiresProviderVerification": requiresProviderVerification,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityVoucherAccess &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityVoucherAccess(redacted)';
}
