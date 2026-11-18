// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'slot.dart';

class ActivityAvailability {
  ActivityAvailability({
    required this.productId,
    required this.optionId,
    required this.evaluatedAt,
    List<ActivitySlot> slots = const [],
    this.bookable = false,
    this.state = "unknown",
    required this.travelerCount,
    List<String> warningCodes = const [],
    this.earliestAt,
  }) : slots = List.unmodifiable(slots),
       warningCodes = List.unmodifiable(warningCodes);

  final String productId;
  final String optionId;
  final DateTime evaluatedAt;
  final List<ActivitySlot> slots;
  final bool bookable;
  final String state;
  final int travelerCount;
  final List<String> warningCodes;
  final DateTime? earliestAt;

  factory ActivityAvailability.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "productId",
      "optionId",
      "evaluatedAt",
      "slots",
      "bookable",
      "state",
      "travelerCount",
      "warningCodes",
      "earliestAt",
    });
    final value = ActivityAvailability(
      productId: ActivityCodec.text(json, 'productId', required: true)!,
      optionId: ActivityCodec.text(json, 'optionId', required: true)!,
      evaluatedAt: ActivityCodec.date(json, 'evaluatedAt', required: true)!,
      slots:
          ActivityCodec.list(
            json,
            'slots',
            (v) => ActivitySlot.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      bookable: ActivityCodec.boolean(json, 'bookable') ?? false,
      state: ActivityCodec.text(json, 'state') ?? "unknown",
      travelerCount: ActivityCodec.integer(
        json,
        'travelerCount',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      warningCodes:
          ActivityCodec.list(json, 'warningCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      earliestAt: ActivityCodec.date(json, 'earliestAt'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityAvailability> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityAvailability.fromJson(ActivityCodec.object(input)),
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

  ActivityAvailability copyWith({
    Set<String> clear = const {},
    String? productId,
    String? optionId,
    DateTime? evaluatedAt,
    List<ActivitySlot>? slots,
    bool? bookable,
    String? state,
    int? travelerCount,
    List<String>? warningCodes,
    DateTime? earliestAt,
  }) {
    final clearableFields = <String>{"earliestAt"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityAvailability(
      productId: (productId ?? this.productId),
      optionId: (optionId ?? this.optionId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      slots: (slots ?? this.slots),
      bookable: (bookable ?? this.bookable),
      state: (state ?? this.state),
      travelerCount: (travelerCount ?? this.travelerCount),
      warningCodes: (warningCodes ?? this.warningCodes),
      earliestAt: clear.contains('earliestAt')
          ? null
          : (earliestAt ?? this.earliestAt),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
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
      if (slots.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'slots',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < slots.length; i++)
        for (final issue in slots[i].validate())
          validationIssues.add(
            ActivityIssue(
              'slots[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
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
      if (travelerCount < 0 || travelerCount > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'travelerCount',
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
    if (travelerCount < 1 ||
        travelerCount > 100 ||
        !{
          'unknown',
          'available',
          'unavailable',
          'insufficientCapacity',
          'stale',
        }.contains(state) ||
        slots.any((s) => s.productId != productId || s.optionId != optionId) ||
        slots.map((s) => s.id).toSet().length != slots.length)
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
    "productId": productId,
    "optionId": optionId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "slots": slots.map((item) => item.toJson()).toList(),
    "bookable": bookable,
    "state": state,
    "travelerCount": travelerCount,
    "warningCodes": warningCodes,
    if (earliestAt != null) "earliestAt": earliestAt!.toUtc().toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityAvailability &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityAvailability(redacted)';
}
