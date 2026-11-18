// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'provider_failure.dart';
import 'provider_page.dart';

class ActivityDiscoveryState {
  ActivityDiscoveryState({
    required this.requestId,
    required this.scopeFingerprint,
    required this.updatedAt,
    required this.state,
    this.page,
    this.failure,
    this.generation = 1,
    this.attempt = 1,
  });

  final String requestId;
  final String scopeFingerprint;
  final DateTime updatedAt;
  final String state;
  final ActivityProviderPage? page;
  final ActivityProviderFailure? failure;
  final int generation;
  final int attempt;

  factory ActivityDiscoveryState.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "requestId",
      "scopeFingerprint",
      "updatedAt",
      "state",
      "page",
      "failure",
      "generation",
      "attempt",
    });
    final value = ActivityDiscoveryState(
      requestId: ActivityCodec.text(json, 'requestId', required: true)!,
      scopeFingerprint: ActivityCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
      state: ActivityCodec.text(json, 'state', required: true)!,
      page: json['page'] == null
          ? null
          : ActivityProviderPage.fromJson(ActivityCodec.object(json['page'])),
      failure: json['failure'] == null
          ? null
          : ActivityProviderFailure.fromJson(
              ActivityCodec.object(json['failure']),
            ),
      generation:
          ActivityCodec.integer(
            json,
            'generation',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      attempt:
          ActivityCodec.integer(
            json,
            'attempt',
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

  static ActivityResult<ActivityDiscoveryState> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityDiscoveryState.fromJson(ActivityCodec.object(input)),
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

  ActivityDiscoveryState copyWith({
    Set<String> clear = const {},
    String? requestId,
    String? scopeFingerprint,
    DateTime? updatedAt,
    String? state,
    ActivityProviderPage? page,
    ActivityProviderFailure? failure,
    int? generation,
    int? attempt,
  }) {
    final clearableFields = <String>{"page", "failure"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityDiscoveryState(
      requestId: (requestId ?? this.requestId),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      updatedAt: (updatedAt ?? this.updatedAt),
      state: (state ?? this.state),
      page: clear.contains('page') ? null : (page ?? this.page),
      failure: clear.contains('failure') ? null : (failure ?? this.failure),
      generation: (generation ?? this.generation),
      attempt: (attempt ?? this.attempt),
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
      if (scopeFingerprint.trim().isEmpty || scopeFingerprint.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'scopeFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const ActivityIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    if (page != null) {
      for (final issue in page!.validate())
        validationIssues.add(
          ActivityIssue(
            'page.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (failure != null) {
      for (final issue in failure!.validate())
        validationIssues.add(
          ActivityIssue(
            'failure.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (generation < 0 || generation > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'generation',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (attempt < 0 || attempt > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'attempt',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (generation < 1 ||
        attempt < 1 ||
        attempt > 3 ||
        !{'loading', 'ready', 'failed', 'cancelled'}.contains(state) ||
        state == 'ready' && page == null ||
        state == 'failed' && failure == null ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(scopeFingerprint))
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
    "scopeFingerprint": scopeFingerprint,
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "state": state,
    if (page != null) "page": page!.toJson(),
    if (failure != null) "failure": failure!.toJson(),
    "generation": generation,
    "attempt": attempt,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityDiscoveryState &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityDiscoveryState(redacted)';
}
