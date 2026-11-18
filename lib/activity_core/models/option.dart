// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'age_band.dart';
import 'duration.dart';
import 'guide_language.dart';
import 'price_rule.dart';

class ActivityOption {
  ActivityOption({
    required this.id,
    required this.productId,
    required this.title,
    List<ActivityPriceRule> priceRules = const [],
    List<ActivityGuideLanguage> languages = const [],
    List<ActivityAgeBand> ageBands = const [],
    this.minimumTravelers = 1,
    this.maximumTravelers = 100,
    this.duration,
    this.meetingPointId,
    this.active = true,
  }) : priceRules = List.unmodifiable(priceRules),
       languages = List.unmodifiable(languages),
       ageBands = List.unmodifiable(ageBands);

  final String id;
  final String productId;
  final String title;
  final List<ActivityPriceRule> priceRules;
  final List<ActivityGuideLanguage> languages;
  final List<ActivityAgeBand> ageBands;
  final int minimumTravelers;
  final int maximumTravelers;
  final ActivityDuration? duration;
  final String? meetingPointId;
  final bool active;

  factory ActivityOption.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "productId",
      "title",
      "priceRules",
      "languages",
      "ageBands",
      "minimumTravelers",
      "maximumTravelers",
      "duration",
      "meetingPointId",
      "active",
    });
    final value = ActivityOption(
      id: ActivityCodec.text(json, 'id', required: true)!,
      productId: ActivityCodec.text(json, 'productId', required: true)!,
      title: ActivityCodec.text(json, 'title', required: true)!,
      priceRules:
          ActivityCodec.list(
            json,
            'priceRules',
            (v) => ActivityPriceRule.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      languages:
          ActivityCodec.list(
            json,
            'languages',
            (v) => ActivityGuideLanguage.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      ageBands:
          ActivityCodec.list(
            json,
            'ageBands',
            (v) => ActivityAgeBand.fromJson(ActivityCodec.object(v)),
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
      duration: json['duration'] == null
          ? null
          : ActivityDuration.fromJson(ActivityCodec.object(json['duration'])),
      meetingPointId: ActivityCodec.text(json, 'meetingPointId'),
      active: ActivityCodec.boolean(json, 'active') ?? true,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityOption> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityOption.fromJson(ActivityCodec.object(input)),
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

  ActivityOption copyWith({
    Set<String> clear = const {},
    String? id,
    String? productId,
    String? title,
    List<ActivityPriceRule>? priceRules,
    List<ActivityGuideLanguage>? languages,
    List<ActivityAgeBand>? ageBands,
    int? minimumTravelers,
    int? maximumTravelers,
    ActivityDuration? duration,
    String? meetingPointId,
    bool? active,
  }) {
    final clearableFields = <String>{"duration", "meetingPointId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityOption(
      id: (id ?? this.id),
      productId: (productId ?? this.productId),
      title: (title ?? this.title),
      priceRules: (priceRules ?? this.priceRules),
      languages: (languages ?? this.languages),
      ageBands: (ageBands ?? this.ageBands),
      minimumTravelers: (minimumTravelers ?? this.minimumTravelers),
      maximumTravelers: (maximumTravelers ?? this.maximumTravelers),
      duration: clear.contains('duration') ? null : (duration ?? this.duration),
      meetingPointId: clear.contains('meetingPointId')
          ? null
          : (meetingPointId ?? this.meetingPointId),
      active: (active ?? this.active),
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
      if (title.trim().isEmpty || title.length > 4000)
        validationIssues.add(
          const ActivityIssue('title', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (priceRules.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'priceRules',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < priceRules.length; i++)
        for (final issue in priceRules[i].validate())
          validationIssues.add(
            ActivityIssue(
              'priceRules[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (languages.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'languages',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < languages.length; i++)
        for (final issue in languages[i].validate())
          validationIssues.add(
            ActivityIssue(
              'languages[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (ageBands.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'ageBands',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < ageBands.length; i++)
        for (final issue in ageBands[i].validate())
          validationIssues.add(
            ActivityIssue(
              'ageBands[$i].${issue.field}',
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
    if (duration != null) {
      for (final issue in duration!.validate())
        validationIssues.add(
          ActivityIssue(
            'duration.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (meetingPointId != null) {
      if (meetingPointId!.trim().isEmpty || meetingPointId!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'meetingPointId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (minimumTravelers < 1 ||
        maximumTravelers > 100 ||
        minimumTravelers > maximumTravelers ||
        priceRules.map((p) => p.id).toSet().length != priceRules.length)
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
    "title": title,
    "priceRules": priceRules.map((item) => item.toJson()).toList(),
    "languages": languages.map((item) => item.toJson()).toList(),
    "ageBands": ageBands.map((item) => item.toJson()).toList(),
    "minimumTravelers": minimumTravelers,
    "maximumTravelers": maximumTravelers,
    if (duration != null) "duration": duration!.toJson(),
    if (meetingPointId != null) "meetingPointId": meetingPointId,
    "active": active,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityOption && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityOption(redacted)';
}
