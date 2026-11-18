// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'traveler.dart';

class ActivityTravelerMix {
  ActivityTravelerMix({
    List<ActivityTraveler> travelers = const [],
    this.minimumTravelers = 1,
    this.maximumTravelers = 100,
    this.pricingBasis = "perPerson",
    this.revision = 1,
  }) : travelers = List.unmodifiable(travelers);

  final List<ActivityTraveler> travelers;
  final int minimumTravelers;
  final int maximumTravelers;
  final String pricingBasis;
  final int revision;

  factory ActivityTravelerMix.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "travelers",
      "minimumTravelers",
      "maximumTravelers",
      "pricingBasis",
      "revision",
    });
    final value = ActivityTravelerMix(
      travelers:
          ActivityCodec.list(
            json,
            'travelers',
            (v) => ActivityTraveler.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      minimumTravelers:
          ActivityCodec.integer(
            json,
            'minimumTravelers',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      maximumTravelers:
          ActivityCodec.integer(
            json,
            'maximumTravelers',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          100,
      pricingBasis: ActivityCodec.text(json, 'pricingBasis') ?? "perPerson",
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

  static ActivityResult<ActivityTravelerMix> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityTravelerMix.fromJson(ActivityCodec.object(input)),
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

  ActivityTravelerMix copyWith({
    Set<String> clear = const {},
    List<ActivityTraveler>? travelers,
    int? minimumTravelers,
    int? maximumTravelers,
    String? pricingBasis,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityTravelerMix(
      travelers: (travelers ?? this.travelers),
      minimumTravelers: (minimumTravelers ?? this.minimumTravelers),
      maximumTravelers: (maximumTravelers ?? this.maximumTravelers),
      pricingBasis: (pricingBasis ?? this.pricingBasis),
      revision: (revision ?? this.revision),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (travelers.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'travelers',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < travelers.length; i++)
        for (final issue in travelers[i].validate())
          validationIssues.add(
            ActivityIssue(
              'travelers[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (minimumTravelers < 0 || minimumTravelers > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'minimumTravelers',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (maximumTravelers < 0 || maximumTravelers > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumTravelers',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (pricingBasis.trim().isEmpty || pricingBasis.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'pricingBasis',
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
    if (revision < 1 ||
        minimumTravelers < 1 ||
        maximumTravelers > 100 ||
        minimumTravelers > maximumTravelers ||
        travelers.map((t) => t.id).toSet().length != travelers.length ||
        !{'perPerson', 'perGroup', 'perUnit', 'unknown'}.contains(pricingBasis))
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
    "travelers": travelers.map((item) => item.toJson()).toList(),
    "minimumTravelers": minimumTravelers,
    "maximumTravelers": maximumTravelers,
    "pricingBasis": pricingBasis,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityTravelerMix &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityTravelerMix(redacted)';
}
