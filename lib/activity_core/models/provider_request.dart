// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'availability_request.dart';
import 'search_query.dart';

class ActivityProviderRequest {
  ActivityProviderRequest({
    required this.id,
    required this.scope,
    required this.createdAt,
    required this.mode,
    this.query,
    this.availability,
    this.productId,
    this.optionId,
    this.slotId,
    this.cursor,
    this.limit = 20,
    List<String> fieldMask = const [],
  }) : fieldMask = List.unmodifiable(fieldMask);

  final String id;
  final String scope;
  final DateTime createdAt;
  final String mode;
  final ActivitySearchQuery? query;
  final ActivityAvailabilityRequest? availability;
  final String? productId;
  final String? optionId;
  final String? slotId;
  final String? cursor;
  final int limit;
  final List<String> fieldMask;

  factory ActivityProviderRequest.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "createdAt",
      "mode",
      "query",
      "availability",
      "productId",
      "optionId",
      "slotId",
      "cursor",
      "limit",
      "fieldMask",
    });
    final value = ActivityProviderRequest(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      mode: ActivityCodec.text(json, 'mode', required: true)!,
      query: json['query'] == null
          ? null
          : ActivitySearchQuery.fromJson(ActivityCodec.object(json['query'])),
      availability: json['availability'] == null
          ? null
          : ActivityAvailabilityRequest.fromJson(
              ActivityCodec.object(json['availability']),
            ),
      productId: ActivityCodec.text(json, 'productId'),
      optionId: ActivityCodec.text(json, 'optionId'),
      slotId: ActivityCodec.text(json, 'slotId'),
      cursor: ActivityCodec.text(json, 'cursor'),
      limit:
          ActivityCodec.integer(
            json,
            'limit',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          20,
      fieldMask:
          ActivityCodec.list(json, 'fieldMask', (v) {
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

  static ActivityResult<ActivityProviderRequest> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityProviderRequest.fromJson(ActivityCodec.object(input)),
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

  ActivityProviderRequest copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    DateTime? createdAt,
    String? mode,
    ActivitySearchQuery? query,
    ActivityAvailabilityRequest? availability,
    String? productId,
    String? optionId,
    String? slotId,
    String? cursor,
    int? limit,
    List<String>? fieldMask,
  }) {
    final clearableFields = <String>{
      "query",
      "availability",
      "productId",
      "optionId",
      "slotId",
      "cursor",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityProviderRequest(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      createdAt: (createdAt ?? this.createdAt),
      mode: (mode ?? this.mode),
      query: clear.contains('query') ? null : (query ?? this.query),
      availability: clear.contains('availability')
          ? null
          : (availability ?? this.availability),
      productId: clear.contains('productId')
          ? null
          : (productId ?? this.productId),
      optionId: clear.contains('optionId') ? null : (optionId ?? this.optionId),
      slotId: clear.contains('slotId') ? null : (slotId ?? this.slotId),
      cursor: clear.contains('cursor') ? null : (cursor ?? this.cursor),
      limit: (limit ?? this.limit),
      fieldMask: (fieldMask ?? this.fieldMask),
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
      if (mode.trim().isEmpty || mode.length > 4000)
        validationIssues.add(
          const ActivityIssue('mode', 'text', 'Use nonempty bounded text'),
        );
    }
    if (query != null) {
      for (final issue in query!.validate())
        validationIssues.add(
          ActivityIssue(
            'query.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (availability != null) {
      for (final issue in availability!.validate())
        validationIssues.add(
          ActivityIssue(
            'availability.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (productId != null) {
      if (productId!.trim().isEmpty || productId!.length > 4000)
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
    if (cursor != null) {
      if (cursor!.trim().isEmpty || cursor!.length > 4000)
        validationIssues.add(
          const ActivityIssue('cursor', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (limit < 0 || limit > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'limit',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (fieldMask.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'fieldMask',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (fieldMask.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'fieldMask',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (!{'search', 'details', 'availability', 'quote'}.contains(mode) ||
        limit < 1 ||
        limit > 100 ||
        scope.length > 120 ||
        mode == 'search' && query == null ||
        mode == 'details' && productId == null ||
        (mode == 'availability' || mode == 'quote') && availability == null)
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
    "createdAt": createdAt.toUtc().toIso8601String(),
    "mode": mode,
    if (query != null) "query": query!.toJson(),
    if (availability != null) "availability": availability!.toJson(),
    if (productId != null) "productId": productId,
    if (optionId != null) "optionId": optionId,
    if (slotId != null) "slotId": slotId,
    if (cursor != null) "cursor": cursor,
    "limit": limit,
    "fieldMask": fieldMask,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityProviderRequest &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityProviderRequest(redacted)';
}
