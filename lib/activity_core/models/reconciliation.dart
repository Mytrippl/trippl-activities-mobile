// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityReconciliation {
  ActivityReconciliation({
    required this.bookingId,
    required this.evaluatedAt,
    required this.previousState,
    required this.nextState,
    required this.accepted,
    List<String> reasonCodes = const [],
    this.requiresReview = true,
    this.remoteRevision = 1,
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String bookingId;
  final DateTime evaluatedAt;
  final String previousState;
  final String nextState;
  final bool accepted;
  final List<String> reasonCodes;
  final bool requiresReview;
  final int remoteRevision;

  factory ActivityReconciliation.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "bookingId",
      "evaluatedAt",
      "previousState",
      "nextState",
      "accepted",
      "reasonCodes",
      "requiresReview",
      "remoteRevision",
    });
    final value = ActivityReconciliation(
      bookingId: ActivityCodec.text(json, 'bookingId', required: true)!,
      evaluatedAt: ActivityCodec.date(json, 'evaluatedAt', required: true)!,
      previousState: ActivityCodec.text(json, 'previousState', required: true)!,
      nextState: ActivityCodec.text(json, 'nextState', required: true)!,
      accepted: ActivityCodec.boolean(json, 'accepted', required: true)!,
      reasonCodes:
          ActivityCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      requiresReview: ActivityCodec.boolean(json, 'requiresReview') ?? true,
      remoteRevision:
          ActivityCodec.integer(
            json,
            'remoteRevision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityReconciliation> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityReconciliation.fromJson(ActivityCodec.object(input)),
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

  ActivityReconciliation copyWith({
    Set<String> clear = const {},
    String? bookingId,
    DateTime? evaluatedAt,
    String? previousState,
    String? nextState,
    bool? accepted,
    List<String>? reasonCodes,
    bool? requiresReview,
    int? remoteRevision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityReconciliation(
      bookingId: (bookingId ?? this.bookingId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      previousState: (previousState ?? this.previousState),
      nextState: (nextState ?? this.nextState),
      accepted: (accepted ?? this.accepted),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      requiresReview: (requiresReview ?? this.requiresReview),
      remoteRevision: (remoteRevision ?? this.remoteRevision),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (bookingId.trim().isEmpty || bookingId.length > 4000)
        validationIssues.add(
          const ActivityIssue('bookingId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (previousState.trim().isEmpty || previousState.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'previousState',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (nextState.trim().isEmpty || nextState.length > 4000)
        validationIssues.add(
          const ActivityIssue('nextState', 'text', 'Use nonempty bounded text'),
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
    {
      if (remoteRevision < 0 || remoteRevision > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'remoteRevision',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (remoteRevision < 1)
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
    "bookingId": bookingId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "previousState": previousState,
    "nextState": nextState,
    "accepted": accepted,
    "reasonCodes": reasonCodes,
    "requiresReview": requiresReview,
    "remoteRevision": remoteRevision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityReconciliation &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityReconciliation(redacted)';
}
