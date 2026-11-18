// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'money.dart';
import 'price_component.dart';

class ActivityPriceQuote {
  ActivityPriceQuote({
    required this.id,
    required this.productId,
    required this.optionId,
    required this.requestFingerprint,
    required this.observedAt,
    required this.expiresAt,
    required this.total,
    List<ActivityPriceComponent> components = const [],
    this.indicative = true,
    this.slotId,
    this.revision = 1,
  }) : components = List.unmodifiable(components);

  final String id;
  final String productId;
  final String optionId;
  final String requestFingerprint;
  final DateTime observedAt;
  final DateTime expiresAt;
  final ActivityMoney total;
  final List<ActivityPriceComponent> components;
  final bool indicative;
  final String? slotId;
  final int revision;

  factory ActivityPriceQuote.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "productId",
      "optionId",
      "requestFingerprint",
      "observedAt",
      "expiresAt",
      "total",
      "components",
      "indicative",
      "slotId",
      "revision",
    });
    final value = ActivityPriceQuote(
      id: ActivityCodec.text(json, 'id', required: true)!,
      productId: ActivityCodec.text(json, 'productId', required: true)!,
      optionId: ActivityCodec.text(json, 'optionId', required: true)!,
      requestFingerprint: ActivityCodec.text(
        json,
        'requestFingerprint',
        required: true,
      )!,
      observedAt: ActivityCodec.date(json, 'observedAt', required: true)!,
      expiresAt: ActivityCodec.date(json, 'expiresAt', required: true)!,
      total: (json['total'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['total'])))!,
      components:
          ActivityCodec.list(
            json,
            'components',
            (v) => ActivityPriceComponent.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      indicative: ActivityCodec.boolean(json, 'indicative') ?? true,
      slotId: ActivityCodec.text(json, 'slotId'),
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

  static ActivityResult<ActivityPriceQuote> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityPriceQuote.fromJson(ActivityCodec.object(input)),
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

  ActivityPriceQuote copyWith({
    Set<String> clear = const {},
    String? id,
    String? productId,
    String? optionId,
    String? requestFingerprint,
    DateTime? observedAt,
    DateTime? expiresAt,
    ActivityMoney? total,
    List<ActivityPriceComponent>? components,
    bool? indicative,
    String? slotId,
    int? revision,
  }) {
    final clearableFields = <String>{"slotId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityPriceQuote(
      id: (id ?? this.id),
      productId: (productId ?? this.productId),
      optionId: (optionId ?? this.optionId),
      requestFingerprint: (requestFingerprint ?? this.requestFingerprint),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      total: (total ?? this.total),
      components: (components ?? this.components),
      indicative: (indicative ?? this.indicative),
      slotId: clear.contains('slotId') ? null : (slotId ?? this.slotId),
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
      if (productId.trim().isEmpty || productId.length > 4000)
        validationIssues.add(
          const ActivityIssue('productId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (optionId.trim().isEmpty || optionId.length > 4000)
        validationIssues.add(
          const ActivityIssue('optionId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (requestFingerprint.trim().isEmpty || requestFingerprint.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'requestFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      for (final issue in total.validate())
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
      if (components.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'components',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < components.length; i++)
        for (final issue in components[i].validate())
          validationIssues.add(
            ActivityIssue(
              'components[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    if (slotId != null) {
      if (slotId!.trim().isEmpty || slotId!.length > 4000)
        validationIssues.add(
          const ActivityIssue('slotId', 'text', 'Use nonempty bounded text'),
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
        !expiresAt.isAfter(observedAt) ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(requestFingerprint))
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
    "productId": productId,
    "optionId": optionId,
    "requestFingerprint": requestFingerprint,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "total": total.toJson(),
    "components": components.map((item) => item.toJson()).toList(),
    "indicative": indicative,
    if (slotId != null) "slotId": slotId,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityPriceQuote &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityPriceQuote(redacted)';
}
