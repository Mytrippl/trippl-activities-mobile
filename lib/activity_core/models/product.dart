// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'accessibility.dart';
import 'attribution.dart';
import 'cancellation_policy.dart';
import 'coordinate.dart';
import 'duration.dart';
import 'inclusion.dart';
import 'option.dart';
import 'photo.dart';
import 'rating.dart';
import 'review.dart';

class ActivityProduct {
  ActivityProduct({
    required this.id,
    required this.title,
    this.description,
    this.destinationId,
    this.coordinate,
    this.rating,
    this.duration,
    this.cancellation,
    this.accessibility,
    List<ActivityOption> options = const [],
    List<ActivityPhoto> photos = const [],
    List<ActivityReview> reviews = const [],
    List<String> categories = const [],
    List<ActivityInclusion> inclusions = const [],
    List<ActivityAttribution> attributions = const [],
    this.observedAt,
    this.expiresAt,
    this.instantConfirmation = false,
    this.revision = 1,
  }) : options = List.unmodifiable(options),
       photos = List.unmodifiable(photos),
       reviews = List.unmodifiable(reviews),
       categories = List.unmodifiable(categories),
       inclusions = List.unmodifiable(inclusions),
       attributions = List.unmodifiable(attributions);

  final String id;
  final String title;
  final String? description;
  final String? destinationId;
  final ActivityCoordinate? coordinate;
  final ActivityRating? rating;
  final ActivityDuration? duration;
  final ActivityCancellationPolicy? cancellation;
  final ActivityAccessibility? accessibility;
  final List<ActivityOption> options;
  final List<ActivityPhoto> photos;
  final List<ActivityReview> reviews;
  final List<String> categories;
  final List<ActivityInclusion> inclusions;
  final List<ActivityAttribution> attributions;
  final DateTime? observedAt;
  final DateTime? expiresAt;
  final bool instantConfirmation;
  final int revision;

  factory ActivityProduct.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "title",
      "description",
      "destinationId",
      "coordinate",
      "rating",
      "duration",
      "cancellation",
      "accessibility",
      "options",
      "photos",
      "reviews",
      "categories",
      "inclusions",
      "attributions",
      "observedAt",
      "expiresAt",
      "instantConfirmation",
      "revision",
    });
    final value = ActivityProduct(
      id: ActivityCodec.text(json, 'id', required: true)!,
      title: ActivityCodec.text(json, 'title', required: true)!,
      description: ActivityCodec.text(json, 'description'),
      destinationId: ActivityCodec.text(json, 'destinationId'),
      coordinate: json['coordinate'] == null
          ? null
          : ActivityCoordinate.fromJson(
              ActivityCodec.object(json['coordinate']),
            ),
      rating: json['rating'] == null
          ? null
          : ActivityRating.fromJson(ActivityCodec.object(json['rating'])),
      duration: json['duration'] == null
          ? null
          : ActivityDuration.fromJson(ActivityCodec.object(json['duration'])),
      cancellation: json['cancellation'] == null
          ? null
          : ActivityCancellationPolicy.fromJson(
              ActivityCodec.object(json['cancellation']),
            ),
      accessibility: json['accessibility'] == null
          ? null
          : ActivityAccessibility.fromJson(
              ActivityCodec.object(json['accessibility']),
            ),
      options:
          ActivityCodec.list(
            json,
            'options',
            (v) => ActivityOption.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      photos:
          ActivityCodec.list(
            json,
            'photos',
            (v) => ActivityPhoto.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      reviews:
          ActivityCodec.list(
            json,
            'reviews',
            (v) => ActivityReview.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      categories:
          ActivityCodec.list(json, 'categories', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      inclusions:
          ActivityCodec.list(
            json,
            'inclusions',
            (v) => ActivityInclusion.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      attributions:
          ActivityCodec.list(
            json,
            'attributions',
            (v) => ActivityAttribution.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      observedAt: ActivityCodec.date(json, 'observedAt'),
      expiresAt: ActivityCodec.date(json, 'expiresAt'),
      instantConfirmation:
          ActivityCodec.boolean(json, 'instantConfirmation') ?? false,
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

  static ActivityResult<ActivityProduct> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityProduct.fromJson(ActivityCodec.object(input)),
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

  ActivityProduct copyWith({
    Set<String> clear = const {},
    String? id,
    String? title,
    String? description,
    String? destinationId,
    ActivityCoordinate? coordinate,
    ActivityRating? rating,
    ActivityDuration? duration,
    ActivityCancellationPolicy? cancellation,
    ActivityAccessibility? accessibility,
    List<ActivityOption>? options,
    List<ActivityPhoto>? photos,
    List<ActivityReview>? reviews,
    List<String>? categories,
    List<ActivityInclusion>? inclusions,
    List<ActivityAttribution>? attributions,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? instantConfirmation,
    int? revision,
  }) {
    final clearableFields = <String>{
      "description",
      "destinationId",
      "coordinate",
      "rating",
      "duration",
      "cancellation",
      "accessibility",
      "observedAt",
      "expiresAt",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityProduct(
      id: (id ?? this.id),
      title: (title ?? this.title),
      description: clear.contains('description')
          ? null
          : (description ?? this.description),
      destinationId: clear.contains('destinationId')
          ? null
          : (destinationId ?? this.destinationId),
      coordinate: clear.contains('coordinate')
          ? null
          : (coordinate ?? this.coordinate),
      rating: clear.contains('rating') ? null : (rating ?? this.rating),
      duration: clear.contains('duration') ? null : (duration ?? this.duration),
      cancellation: clear.contains('cancellation')
          ? null
          : (cancellation ?? this.cancellation),
      accessibility: clear.contains('accessibility')
          ? null
          : (accessibility ?? this.accessibility),
      options: (options ?? this.options),
      photos: (photos ?? this.photos),
      reviews: (reviews ?? this.reviews),
      categories: (categories ?? this.categories),
      inclusions: (inclusions ?? this.inclusions),
      attributions: (attributions ?? this.attributions),
      observedAt: clear.contains('observedAt')
          ? null
          : (observedAt ?? this.observedAt),
      expiresAt: clear.contains('expiresAt')
          ? null
          : (expiresAt ?? this.expiresAt),
      instantConfirmation: (instantConfirmation ?? this.instantConfirmation),
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
      if (title.trim().isEmpty || title.length > 4000)
        validationIssues.add(
          const ActivityIssue('title', 'text', 'Use nonempty bounded text'),
        );
    }
    if (description != null) {
      if (description!.trim().isEmpty || description!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'description',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (destinationId != null) {
      if (destinationId!.trim().isEmpty || destinationId!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'destinationId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (coordinate != null) {
      for (final issue in coordinate!.validate())
        validationIssues.add(
          ActivityIssue(
            'coordinate.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (rating != null) {
      for (final issue in rating!.validate())
        validationIssues.add(
          ActivityIssue(
            'rating.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
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
    if (cancellation != null) {
      for (final issue in cancellation!.validate())
        validationIssues.add(
          ActivityIssue(
            'cancellation.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (accessibility != null) {
      for (final issue in accessibility!.validate())
        validationIssues.add(
          ActivityIssue(
            'accessibility.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (options.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'options',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < options.length; i++)
        for (final issue in options[i].validate())
          validationIssues.add(
            ActivityIssue(
              'options[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (photos.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'photos',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < photos.length; i++)
        for (final issue in photos[i].validate())
          validationIssues.add(
            ActivityIssue(
              'photos[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (reviews.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'reviews',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < reviews.length; i++)
        for (final issue in reviews[i].validate())
          validationIssues.add(
            ActivityIssue(
              'reviews[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
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
    {
      if (inclusions.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'inclusions',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < inclusions.length; i++)
        for (final issue in inclusions[i].validate())
          validationIssues.add(
            ActivityIssue(
              'inclusions[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
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
        observedAt != null &&
            expiresAt != null &&
            !expiresAt!.isAfter(observedAt!) ||
        options.any((o) => o.productId != id) ||
        options.map((o) => o.id).toSet().length != options.length)
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
    "title": title,
    if (description != null) "description": description,
    if (destinationId != null) "destinationId": destinationId,
    if (coordinate != null) "coordinate": coordinate!.toJson(),
    if (rating != null) "rating": rating!.toJson(),
    if (duration != null) "duration": duration!.toJson(),
    if (cancellation != null) "cancellation": cancellation!.toJson(),
    if (accessibility != null) "accessibility": accessibility!.toJson(),
    "options": options.map((item) => item.toJson()).toList(),
    "photos": photos.map((item) => item.toJson()).toList(),
    "reviews": reviews.map((item) => item.toJson()).toList(),
    "categories": categories,
    "inclusions": inclusions.map((item) => item.toJson()).toList(),
    "attributions": attributions.map((item) => item.toJson()).toList(),
    if (observedAt != null) "observedAt": observedAt!.toUtc().toIso8601String(),
    if (expiresAt != null) "expiresAt": expiresAt!.toUtc().toIso8601String(),
    "instantConfirmation": instantConfirmation,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityProduct && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityProduct(redacted)';
}
