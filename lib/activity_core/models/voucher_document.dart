// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'attribution.dart';

class ActivityVoucherDocument {
  ActivityVoucherDocument({
    required this.id,
    required this.bookingId,
    required this.kind,
    this.uri,
    this.text,
    this.expiresAt,
    List<ActivityAttribution> attributions = const [],
    this.revision = 1,
  }) : attributions = List.unmodifiable(attributions);

  final String id;
  final String bookingId;
  final String kind;
  final String? uri;
  final String? text;
  final DateTime? expiresAt;
  final List<ActivityAttribution> attributions;
  final int revision;

  factory ActivityVoucherDocument.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "bookingId",
      "kind",
      "uri",
      "text",
      "expiresAt",
      "attributions",
      "revision",
    });
    final value = ActivityVoucherDocument(
      id: ActivityCodec.text(json, 'id', required: true)!,
      bookingId: ActivityCodec.text(json, 'bookingId', required: true)!,
      kind: ActivityCodec.text(json, 'kind', required: true)!,
      uri: ActivityCodec.text(json, 'uri'),
      text: ActivityCodec.text(json, 'text'),
      expiresAt: ActivityCodec.date(json, 'expiresAt'),
      attributions:
          ActivityCodec.list(
            json,
            'attributions',
            (v) => ActivityAttribution.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      revision:
          ActivityCodec.integer(
            json,
            'revision',
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

  static ActivityResult<ActivityVoucherDocument> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityVoucherDocument.fromJson(ActivityCodec.object(input)),
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

  ActivityVoucherDocument copyWith({
    Set<String> clear = const {},
    String? id,
    String? bookingId,
    String? kind,
    String? uri,
    String? text,
    DateTime? expiresAt,
    List<ActivityAttribution>? attributions,
    int? revision,
  }) {
    final clearableFields = <String>{"uri", "text", "expiresAt"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityVoucherDocument(
      id: (id ?? this.id),
      bookingId: (bookingId ?? this.bookingId),
      kind: (kind ?? this.kind),
      uri: clear.contains('uri') ? null : (uri ?? this.uri),
      text: clear.contains('text') ? null : (text ?? this.text),
      expiresAt: clear.contains('expiresAt')
          ? null
          : (expiresAt ?? this.expiresAt),
      attributions: (attributions ?? this.attributions),
      revision: (revision ?? this.revision),
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
      if (bookingId.trim().isEmpty || bookingId.length > 4000)
        validationIssues.add(
          const ActivityIssue('bookingId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const ActivityIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    if (uri != null) {
      if (uri!.trim().isEmpty || uri!.length > 4000)
        validationIssues.add(
          const ActivityIssue('uri', 'text', 'Use nonempty bounded text'),
        );
    }
    if (text != null) {
      if (text!.trim().isEmpty || text!.length > 4000)
        validationIssues.add(
          const ActivityIssue('text', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (attributions.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'attributions',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < attributions.length; i++)
        for (final issue in attributions[i].validate())
          validationIssues.add(
            ActivityIssue(
              'attributions[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
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
    if (revision < 1 ||
        !{'link', 'text', 'barcode'}.contains(kind) ||
        kind == 'link' && uri == null ||
        kind != 'link' && text == null)
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
    "bookingId": bookingId,
    "kind": kind,
    if (uri != null) "uri": uri,
    if (text != null) "text": text,
    if (expiresAt != null) "expiresAt": expiresAt!.toUtc().toIso8601String(),
    "attributions": attributions.map((item) => item.toJson()).toList(),
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityVoucherDocument &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityVoucherDocument(redacted)';
}
