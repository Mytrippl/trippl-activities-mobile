// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'money.dart';

class ActivityCancellationResult {
  ActivityCancellationResult({
    required this.requestId,
    required this.scope,
    required this.bookingId,
    required this.receivedAt,
    required this.state,
    this.refund,
    this.providerReference,
    this.revision = 1,
    List<String> warningCodes = const [],
  }) : warningCodes = List.unmodifiable(warningCodes);

  final String requestId;
  final String scope;
  final String bookingId;
  final DateTime receivedAt;
  final String state;
  final ActivityMoney? refund;
  final String? providerReference;
  final int revision;
  final List<String> warningCodes;

  factory ActivityCancellationResult.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "requestId",
      "scope",
      "bookingId",
      "receivedAt",
      "state",
      "refund",
      "providerReference",
      "revision",
      "warningCodes",
    });
    final value = ActivityCancellationResult(
      requestId: ActivityCodec.text(json, 'requestId', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      bookingId: ActivityCodec.text(json, 'bookingId', required: true)!,
      receivedAt: ActivityCodec.date(json, 'receivedAt', required: true)!,
      state: ActivityCodec.text(json, 'state', required: true)!,
      refund: json['refund'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['refund'])),
      providerReference: ActivityCodec.text(json, 'providerReference'),
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      warningCodes:
          ActivityCodec.list(json, 'warningCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityCancellationResult> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityCancellationResult.fromJson(ActivityCodec.object(input)),
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

  ActivityCancellationResult copyWith({
    Set<String> clear = const {},
    String? requestId,
    String? scope,
    String? bookingId,
    DateTime? receivedAt,
    String? state,
    ActivityMoney? refund,
    String? providerReference,
    int? revision,
    List<String>? warningCodes,
  }) {
    final clearableFields = <String>{"refund", "providerReference"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityCancellationResult(
      requestId: (requestId ?? this.requestId),
      scope: (scope ?? this.scope),
      bookingId: (bookingId ?? this.bookingId),
      receivedAt: (receivedAt ?? this.receivedAt),
      state: (state ?? this.state),
      refund: clear.contains('refund') ? null : (refund ?? this.refund),
      providerReference: clear.contains('providerReference')
          ? null
          : (providerReference ?? this.providerReference),
      revision: (revision ?? this.revision),
      warningCodes: (warningCodes ?? this.warningCodes),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (requestId.trim().isEmpty || requestId.length > 4000)
        validationIssues.add(
          const ActivityIssue('requestId', 'text', 'Use nonempty bounded text'),
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
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const ActivityIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    if (refund != null) {
      for (final issue in refund!.validate())
        validationIssues.add(
          ActivityIssue(
            'refund.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (providerReference != null) {
      if (providerReference!.trim().isEmpty || providerReference!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'providerReference',
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
    {
      if (warningCodes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'warningCodes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (warningCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'warningCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (revision < 1 ||
        !{'pending', 'cancelled', 'rejected', 'unknown'}.contains(state))
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
    "requestId": requestId,
    "scope": scope,
    "bookingId": bookingId,
    "receivedAt": receivedAt.toUtc().toIso8601String(),
    "state": state,
    if (refund != null) "refund": refund!.toJson(),
    if (providerReference != null) "providerReference": providerReference,
    "revision": revision,
    "warningCodes": warningCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityCancellationResult &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityCancellationResult(redacted)';
}
