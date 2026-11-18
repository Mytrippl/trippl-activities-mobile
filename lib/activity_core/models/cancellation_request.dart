// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityCancellationRequest {
  ActivityCancellationRequest({
    required this.id,
    required this.scope,
    required this.bookingId,
    required this.expectedRevision,
    required this.createdAt,
    required this.idempotencyKey,
    required this.reasonCode,
    this.confirmedByUser = false,
    this.assessmentDigest,
  });

  final String id;
  final String scope;
  final String bookingId;
  final int expectedRevision;
  final DateTime createdAt;
  final String idempotencyKey;
  final String reasonCode;
  final bool confirmedByUser;
  final String? assessmentDigest;

  factory ActivityCancellationRequest.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "bookingId",
      "expectedRevision",
      "createdAt",
      "idempotencyKey",
      "reasonCode",
      "confirmedByUser",
      "assessmentDigest",
    });
    final value = ActivityCancellationRequest(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      bookingId: ActivityCodec.text(json, 'bookingId', required: true)!,
      expectedRevision: ActivityCodec.integer(
        json,
        'expectedRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      idempotencyKey: ActivityCodec.text(
        json,
        'idempotencyKey',
        required: true,
      )!,
      reasonCode: ActivityCodec.text(json, 'reasonCode', required: true)!,
      confirmedByUser: ActivityCodec.boolean(json, 'confirmedByUser') ?? false,
      assessmentDigest: ActivityCodec.text(json, 'assessmentDigest'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityCancellationRequest> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityCancellationRequest.fromJson(
          ActivityCodec.object(input),
        ),
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

  ActivityCancellationRequest copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? bookingId,
    int? expectedRevision,
    DateTime? createdAt,
    String? idempotencyKey,
    String? reasonCode,
    bool? confirmedByUser,
    String? assessmentDigest,
  }) {
    final clearableFields = <String>{"assessmentDigest"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityCancellationRequest(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      bookingId: (bookingId ?? this.bookingId),
      expectedRevision: (expectedRevision ?? this.expectedRevision),
      createdAt: (createdAt ?? this.createdAt),
      idempotencyKey: (idempotencyKey ?? this.idempotencyKey),
      reasonCode: (reasonCode ?? this.reasonCode),
      confirmedByUser: (confirmedByUser ?? this.confirmedByUser),
      assessmentDigest: clear.contains('assessmentDigest')
          ? null
          : (assessmentDigest ?? this.assessmentDigest),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (id.trim().isEmpty || id.length > 4000)
        validationIssues.add(
          const ActivityIssue('id', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (scope.trim().isEmpty || scope.length > 4000)
        validationIssues.add(
          const ActivityIssue('scope', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (bookingId.trim().isEmpty || bookingId.length > 4000)
        validationIssues.add(
          const ActivityIssue('bookingId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (expectedRevision < 0 || expectedRevision > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'expectedRevision',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (idempotencyKey.trim().isEmpty || idempotencyKey.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'idempotencyKey',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (reasonCode.trim().isEmpty || reasonCode.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'reasonCode',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (assessmentDigest != null) {
      if (assessmentDigest!.trim().isEmpty || assessmentDigest!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'assessmentDigest',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (expectedRevision < 1 ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(idempotencyKey) ||
        !RegExp(r'^[A-Za-z0-9_-]{1,80}$').hasMatch(reasonCode))
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
    "id": id,
    "scope": scope,
    "bookingId": bookingId,
    "expectedRevision": expectedRevision,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "idempotencyKey": idempotencyKey,
    "reasonCode": reasonCode,
    "confirmedByUser": confirmedByUser,
    if (assessmentDigest != null) "assessmentDigest": assessmentDigest,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityCancellationRequest &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityCancellationRequest(redacted)';
}
