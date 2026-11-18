// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'money.dart';

class ActivityBookingStatus {
  ActivityBookingStatus({
    required this.bookingId,
    required this.scope,
    required this.observedAt,
    required this.state,
    this.revision = 1,
    this.providerReference,
    this.total,
    List<String> warningCodes = const [],
  }) : warningCodes = List.unmodifiable(warningCodes);

  final String bookingId;
  final String scope;
  final DateTime observedAt;
  final String state;
  final int revision;
  final String? providerReference;
  final ActivityMoney? total;
  final List<String> warningCodes;

  factory ActivityBookingStatus.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "bookingId",
      "scope",
      "observedAt",
      "state",
      "revision",
      "providerReference",
      "total",
      "warningCodes",
    });
    final value = ActivityBookingStatus(
      bookingId: ActivityCodec.text(json, 'bookingId', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      observedAt: ActivityCodec.date(json, 'observedAt', required: true)!,
      state: ActivityCodec.text(json, 'state', required: true)!,
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      providerReference: ActivityCodec.text(json, 'providerReference'),
      total: json['total'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['total'])),
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

  static ActivityResult<ActivityBookingStatus> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityBookingStatus.fromJson(ActivityCodec.object(input)),
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

  ActivityBookingStatus copyWith({
    Set<String> clear = const {},
    String? bookingId,
    String? scope,
    DateTime? observedAt,
    String? state,
    int? revision,
    String? providerReference,
    ActivityMoney? total,
    List<String>? warningCodes,
  }) {
    final clearableFields = <String>{"providerReference", "total"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityBookingStatus(
      bookingId: (bookingId ?? this.bookingId),
      scope: (scope ?? this.scope),
      observedAt: (observedAt ?? this.observedAt),
      state: (state ?? this.state),
      revision: (revision ?? this.revision),
      providerReference: clear.contains('providerReference')
          ? null
          : (providerReference ?? this.providerReference),
      total: clear.contains('total') ? null : (total ?? this.total),
      warningCodes: (warningCodes ?? this.warningCodes),
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
      if (scope.trim().isEmpty || scope.length > 4000)
        validationIssues.add(
          const ActivityIssue('scope', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const ActivityIssue('state', 'text', 'Use nonempty bounded text'),
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
    if (total != null) {
      for (final issue in total!.validate())
        validationIssues.add(
          ActivityIssue(
            'total.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
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
        !{
          'pending',
          'confirmed',
          'rejected',
          'cancelPending',
          'cancelled',
          'unknown',
        }.contains(state))
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
    "scope": scope,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "state": state,
    "revision": revision,
    if (providerReference != null) "providerReference": providerReference,
    if (total != null) "total": total!.toJson(),
    "warningCodes": warningCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityBookingStatus &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityBookingStatus(redacted)';
}
