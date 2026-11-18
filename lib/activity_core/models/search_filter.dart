// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'coordinate.dart';

class ActivitySearchFilter {
  ActivitySearchFilter({
    List<String> categories = const [],
    this.minimumPriceMinor,
    this.maximumPriceMinor,
    this.currency,
    this.minimumRating,
    this.minimumDurationMinutes,
    this.maximumDurationMinutes,
    this.guideLanguage,
    this.freeCancellationOnly = false,
    this.instantConfirmationOnly = false,
    this.includeStale = false,
    this.wheelchairAccessible,
    this.center,
    this.radiusMeters,
  }) : categories = List.unmodifiable(categories);

  final List<String> categories;
  final int? minimumPriceMinor;
  final int? maximumPriceMinor;
  final String? currency;
  final double? minimumRating;
  final int? minimumDurationMinutes;
  final int? maximumDurationMinutes;
  final String? guideLanguage;
  final bool freeCancellationOnly;
  final bool instantConfirmationOnly;
  final bool includeStale;
  final bool? wheelchairAccessible;
  final ActivityCoordinate? center;
  final int? radiusMeters;

  factory ActivitySearchFilter.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "categories",
      "minimumPriceMinor",
      "maximumPriceMinor",
      "currency",
      "minimumRating",
      "minimumDurationMinutes",
      "maximumDurationMinutes",
      "guideLanguage",
      "freeCancellationOnly",
      "instantConfirmationOnly",
      "includeStale",
      "wheelchairAccessible",
      "center",
      "radiusMeters",
    });
    final value = ActivitySearchFilter(
      categories:
          ActivityCodec.list(json, 'categories', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      minimumPriceMinor: ActivityCodec.integer(
        json,
        'minimumPriceMinor',
        minimum: 0,
        maximum: 9000000000000,
      ),
      maximumPriceMinor: ActivityCodec.integer(
        json,
        'maximumPriceMinor',
        minimum: 0,
        maximum: 9000000000000,
      ),
      currency: ActivityCodec.text(json, 'currency'),
      minimumRating: ActivityCodec.decimal(json, 'minimumRating'),
      minimumDurationMinutes: ActivityCodec.integer(
        json,
        'minimumDurationMinutes',
        minimum: 0,
        maximum: 9000000000000,
      ),
      maximumDurationMinutes: ActivityCodec.integer(
        json,
        'maximumDurationMinutes',
        minimum: 0,
        maximum: 9000000000000,
      ),
      guideLanguage: ActivityCodec.text(json, 'guideLanguage'),
      freeCancellationOnly:
          ActivityCodec.boolean(json, 'freeCancellationOnly') ?? false,
      instantConfirmationOnly:
          ActivityCodec.boolean(json, 'instantConfirmationOnly') ?? false,
      includeStale: ActivityCodec.boolean(json, 'includeStale') ?? false,
      wheelchairAccessible: ActivityCodec.boolean(json, 'wheelchairAccessible'),
      center: json['center'] == null
          ? null
          : ActivityCoordinate.fromJson(ActivityCodec.object(json['center'])),
      radiusMeters: ActivityCodec.integer(
        json,
        'radiusMeters',
        minimum: 0,
        maximum: 9000000000000,
      ),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivitySearchFilter> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivitySearchFilter.fromJson(ActivityCodec.object(input)),
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

  ActivitySearchFilter copyWith({
    Set<String> clear = const {},
    List<String>? categories,
    int? minimumPriceMinor,
    int? maximumPriceMinor,
    String? currency,
    double? minimumRating,
    int? minimumDurationMinutes,
    int? maximumDurationMinutes,
    String? guideLanguage,
    bool? freeCancellationOnly,
    bool? instantConfirmationOnly,
    bool? includeStale,
    bool? wheelchairAccessible,
    ActivityCoordinate? center,
    int? radiusMeters,
  }) {
    final clearableFields = <String>{
      "minimumPriceMinor",
      "maximumPriceMinor",
      "currency",
      "minimumRating",
      "minimumDurationMinutes",
      "maximumDurationMinutes",
      "guideLanguage",
      "wheelchairAccessible",
      "center",
      "radiusMeters",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivitySearchFilter(
      categories: (categories ?? this.categories),
      minimumPriceMinor: clear.contains('minimumPriceMinor')
          ? null
          : (minimumPriceMinor ?? this.minimumPriceMinor),
      maximumPriceMinor: clear.contains('maximumPriceMinor')
          ? null
          : (maximumPriceMinor ?? this.maximumPriceMinor),
      currency: clear.contains('currency') ? null : (currency ?? this.currency),
      minimumRating: clear.contains('minimumRating')
          ? null
          : (minimumRating ?? this.minimumRating),
      minimumDurationMinutes: clear.contains('minimumDurationMinutes')
          ? null
          : (minimumDurationMinutes ?? this.minimumDurationMinutes),
      maximumDurationMinutes: clear.contains('maximumDurationMinutes')
          ? null
          : (maximumDurationMinutes ?? this.maximumDurationMinutes),
      guideLanguage: clear.contains('guideLanguage')
          ? null
          : (guideLanguage ?? this.guideLanguage),
      freeCancellationOnly: (freeCancellationOnly ?? this.freeCancellationOnly),
      instantConfirmationOnly:
          (instantConfirmationOnly ?? this.instantConfirmationOnly),
      includeStale: (includeStale ?? this.includeStale),
      wheelchairAccessible: clear.contains('wheelchairAccessible')
          ? null
          : (wheelchairAccessible ?? this.wheelchairAccessible),
      center: clear.contains('center') ? null : (center ?? this.center),
      radiusMeters: clear.contains('radiusMeters')
          ? null
          : (radiusMeters ?? this.radiusMeters),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (categories.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'categories',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (categories.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'categories',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (minimumPriceMinor != null) {
      if (minimumPriceMinor! < 0 || minimumPriceMinor! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'minimumPriceMinor',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (maximumPriceMinor != null) {
      if (maximumPriceMinor! < 0 || maximumPriceMinor! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumPriceMinor',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (currency != null) {
      if (currency!.trim().isEmpty || currency!.length > 4000)
        validationIssues.add(
          const ActivityIssue('currency', 'text', 'Use nonempty bounded text'),
        );
    }
    if (minimumRating != null) {
      if (!minimumRating!.isFinite)
        validationIssues.add(
          const ActivityIssue(
            'minimumRating',
            'finite',
            'Use a finite coordinate or weight',
          ),
        );
    }
    if (minimumDurationMinutes != null) {
      if (minimumDurationMinutes! < 0 ||
          minimumDurationMinutes! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'minimumDurationMinutes',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (maximumDurationMinutes != null) {
      if (maximumDurationMinutes! < 0 ||
          maximumDurationMinutes! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumDurationMinutes',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (guideLanguage != null) {
      if (guideLanguage!.trim().isEmpty || guideLanguage!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'guideLanguage',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (center != null) {
      for (final issue in center!.validate())
        validationIssues.add(
          ActivityIssue(
            'center.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (radiusMeters != null) {
      if (radiusMeters! < 0 || radiusMeters! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'radiusMeters',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (minimumPriceMinor != null &&
            maximumPriceMinor != null &&
            minimumPriceMinor! > maximumPriceMinor! ||
        (minimumPriceMinor != null || maximumPriceMinor != null) &&
            currency == null ||
        minimumRating != null && (minimumRating! < 0 || minimumRating! > 5) ||
        minimumDurationMinutes != null &&
            maximumDurationMinutes != null &&
            minimumDurationMinutes! > maximumDurationMinutes! ||
        radiusMeters != null &&
            (radiusMeters! < 1 || radiusMeters! > 50000 || center == null))
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
    "categories": categories,
    if (minimumPriceMinor != null) "minimumPriceMinor": minimumPriceMinor,
    if (maximumPriceMinor != null) "maximumPriceMinor": maximumPriceMinor,
    if (currency != null) "currency": currency,
    if (minimumRating != null) "minimumRating": minimumRating,
    if (minimumDurationMinutes != null)
      "minimumDurationMinutes": minimumDurationMinutes,
    if (maximumDurationMinutes != null)
      "maximumDurationMinutes": maximumDurationMinutes,
    if (guideLanguage != null) "guideLanguage": guideLanguage,
    "freeCancellationOnly": freeCancellationOnly,
    "instantConfirmationOnly": instantConfirmationOnly,
    "includeStale": includeStale,
    if (wheelchairAccessible != null)
      "wheelchairAccessible": wheelchairAccessible,
    if (center != null) "center": center!.toJson(),
    if (radiusMeters != null) "radiusMeters": radiusMeters,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivitySearchFilter &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivitySearchFilter(redacted)';
}
