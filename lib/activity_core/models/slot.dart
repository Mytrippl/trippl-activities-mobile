// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivitySlot {
  ActivitySlot({
    required this.id,
    required this.productId,
    required this.optionId,
    required this.startsAt,
    this.endsAt,
    this.remainingCapacity,
    this.state = "unknown",
    required this.observedAt,
    required this.expiresAt,
    List<String> languageCodes = const [],
    this.revision = 1,
  }) : languageCodes = List.unmodifiable(languageCodes);

  final String id;
  final String productId;
  final String optionId;
  final DateTime startsAt;
  final DateTime? endsAt;
  final int? remainingCapacity;
  final String state;
  final DateTime observedAt;
  final DateTime expiresAt;
  final List<String> languageCodes;
  final int revision;

  factory ActivitySlot.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "productId",
      "optionId",
      "startsAt",
      "endsAt",
      "remainingCapacity",
      "state",
      "observedAt",
      "expiresAt",
      "languageCodes",
      "revision",
    });
    final value = ActivitySlot(
      id: ActivityCodec.text(json, 'id', required: true)!,
      productId: ActivityCodec.text(json, 'productId', required: true)!,
      optionId: ActivityCodec.text(json, 'optionId', required: true)!,
      startsAt: ActivityCodec.date(json, 'startsAt', required: true)!,
      endsAt: ActivityCodec.date(json, 'endsAt'),
      remainingCapacity: ActivityCodec.integer(
        json,
        'remainingCapacity',
        minimum: 0,
        maximum: 9000000000000,
      ),
      state: ActivityCodec.text(json, 'state') ?? "unknown",
      observedAt: ActivityCodec.date(json, 'observedAt', required: true)!,
      expiresAt: ActivityCodec.date(json, 'expiresAt', required: true)!,
      languageCodes:
          ActivityCodec.list(json, 'languageCodes', (v) {
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
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivitySlot> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivitySlot.fromJson(ActivityCodec.object(input)),
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

  ActivitySlot copyWith({
    Set<String> clear = const {},
    String? id,
    String? productId,
    String? optionId,
    DateTime? startsAt,
    DateTime? endsAt,
    int? remainingCapacity,
    String? state,
    DateTime? observedAt,
    DateTime? expiresAt,
    List<String>? languageCodes,
    int? revision,
  }) {
    final clearableFields = <String>{"endsAt", "remainingCapacity"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivitySlot(
      id: (id ?? this.id),
      productId: (productId ?? this.productId),
      optionId: (optionId ?? this.optionId),
      startsAt: (startsAt ?? this.startsAt),
      endsAt: clear.contains('endsAt') ? null : (endsAt ?? this.endsAt),
      remainingCapacity: clear.contains('remainingCapacity')
          ? null
          : (remainingCapacity ?? this.remainingCapacity),
      state: (state ?? this.state),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      languageCodes: (languageCodes ?? this.languageCodes),
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
    if (remainingCapacity != null) {
      if (remainingCapacity! < 0 || remainingCapacity! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'remainingCapacity',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const ActivityIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (languageCodes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'languageCodes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (languageCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'languageCodes',
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
        !expiresAt.isAfter(observedAt) ||
        endsAt != null && !endsAt!.isAfter(startsAt) ||
        remainingCapacity != null && remainingCapacity! > 100000 ||
        !{'unknown', 'available', 'soldOut', 'unavailable'}.contains(state))
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
    "startsAt": startsAt.toUtc().toIso8601String(),
    if (endsAt != null) "endsAt": endsAt!.toUtc().toIso8601String(),
    if (remainingCapacity != null) "remainingCapacity": remainingCapacity,
    "state": state,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "languageCodes": languageCodes,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivitySlot && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivitySlot(redacted)';
}
