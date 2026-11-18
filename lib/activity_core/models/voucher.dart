// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'voucher_document.dart';

class ActivityVoucher {
  ActivityVoucher({
    required this.id,
    required this.scope,
    required this.bookingId,
    required this.issuedAt,
    required this.validFrom,
    required this.validUntil,
    List<ActivityVoucherDocument> documents = const [],
    List<String> instructions = const [],
    this.revision = 1,
    this.revoked = false,
  }) : documents = List.unmodifiable(documents),
       instructions = List.unmodifiable(instructions);

  final String id;
  final String scope;
  final String bookingId;
  final DateTime issuedAt;
  final DateTime validFrom;
  final DateTime validUntil;
  final List<ActivityVoucherDocument> documents;
  final List<String> instructions;
  final int revision;
  final bool revoked;

  factory ActivityVoucher.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "bookingId",
      "issuedAt",
      "validFrom",
      "validUntil",
      "documents",
      "instructions",
      "revision",
      "revoked",
    });
    final value = ActivityVoucher(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      bookingId: ActivityCodec.text(json, 'bookingId', required: true)!,
      issuedAt: ActivityCodec.date(json, 'issuedAt', required: true)!,
      validFrom: ActivityCodec.date(json, 'validFrom', required: true)!,
      validUntil: ActivityCodec.date(json, 'validUntil', required: true)!,
      documents:
          ActivityCodec.list(
            json,
            'documents',
            (v) => ActivityVoucherDocument.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      instructions:
          ActivityCodec.list(json, 'instructions', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      revoked: ActivityCodec.boolean(json, 'revoked') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityVoucher> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityVoucher.fromJson(ActivityCodec.object(input)),
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

  ActivityVoucher copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? bookingId,
    DateTime? issuedAt,
    DateTime? validFrom,
    DateTime? validUntil,
    List<ActivityVoucherDocument>? documents,
    List<String>? instructions,
    int? revision,
    bool? revoked,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityVoucher(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      bookingId: (bookingId ?? this.bookingId),
      issuedAt: (issuedAt ?? this.issuedAt),
      validFrom: (validFrom ?? this.validFrom),
      validUntil: (validUntil ?? this.validUntil),
      documents: (documents ?? this.documents),
      instructions: (instructions ?? this.instructions),
      revision: (revision ?? this.revision),
      revoked: (revoked ?? this.revoked),
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
      if (documents.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'documents',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < documents.length; i++)
        for (final issue in documents[i].validate())
          validationIssues.add(
            ActivityIssue(
              'documents[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (instructions.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'instructions',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (instructions.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'instructions',
            'text',
            'Use bounded nonempty list text',
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
        !validUntil.isAfter(validFrom) ||
        documents.any((d) => d.bookingId != bookingId) ||
        documents.map((d) => d.id).toSet().length != documents.length)
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
    "issuedAt": issuedAt.toUtc().toIso8601String(),
    "validFrom": validFrom.toUtc().toIso8601String(),
    "validUntil": validUntil.toUtc().toIso8601String(),
    "documents": documents.map((item) => item.toJson()).toList(),
    "instructions": instructions,
    "revision": revision,
    "revoked": revoked,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityVoucher && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityVoucher(redacted)';
}
