// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivitySupportCase {
  ActivitySupportCase({
    required this.id,
    required this.scope,
    required this.bookingId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.summary,
    this.state = "draft",
    this.revision = 1,
    this.providerReference,
  });

  final String id;
  final String scope;
  final String bookingId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String category;
  final String summary;
  final String state;
  final int revision;
  final String? providerReference;

  factory ActivitySupportCase.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "bookingId",
      "createdAt",
      "updatedAt",
      "category",
      "summary",
      "state",
      "revision",
      "providerReference",
    });
    final value = ActivitySupportCase(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      bookingId: ActivityCodec.text(json, 'bookingId', required: true)!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
      category: ActivityCodec.text(json, 'category', required: true)!,
      summary: ActivityCodec.text(json, 'summary', required: true)!,
      state: ActivityCodec.text(json, 'state') ?? "draft",
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      providerReference: ActivityCodec.text(json, 'providerReference'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivitySupportCase> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivitySupportCase.fromJson(ActivityCodec.object(input)),
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

  ActivitySupportCase copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? bookingId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
    String? summary,
    String? state,
    int? revision,
    String? providerReference,
  }) {
    final clearableFields = <String>{"providerReference"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivitySupportCase(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      bookingId: (bookingId ?? this.bookingId),
      createdAt: (createdAt ?? this.createdAt),
      updatedAt: (updatedAt ?? this.updatedAt),
      category: (category ?? this.category),
      summary: (summary ?? this.summary),
      state: (state ?? this.state),
      revision: (revision ?? this.revision),
      providerReference: clear.contains('providerReference')
          ? null
          : (providerReference ?? this.providerReference),
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
      if (category.trim().isEmpty || category.length > 4000)
        validationIssues.add(
          const ActivityIssue('category', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (summary.trim().isEmpty || summary.length > 4000)
        validationIssues.add(
          const ActivityIssue('summary', 'text', 'Use nonempty bounded text'),
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
    if (revision < 1 ||
        updatedAt.isBefore(createdAt) ||
        summary.length > 1000 ||
        !{
          'booking',
          'pickup',
          'voucher',
          'cancellation',
          'refund',
          'other',
        }.contains(category) ||
        !{'draft', 'submitted', 'open', 'resolved'}.contains(state))
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
    "createdAt": createdAt.toUtc().toIso8601String(),
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "category": category,
    "summary": summary,
    "state": state,
    "revision": revision,
    if (providerReference != null) "providerReference": providerReference,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivitySupportCase &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivitySupportCase(redacted)';
}
