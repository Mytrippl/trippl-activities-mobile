// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'photo.dart';

class ActivityResultCard {
  ActivityResultCard({
    required this.productId,
    required this.title,
    required this.priceLabel,
    required this.ratingLabel,
    required this.durationLabel,
    required this.cancellationLabel,
    required this.availabilityState,
    this.photo,
    this.distanceLabel,
    this.stale = false,
    List<String> warningCodes = const [],
  }) : warningCodes = List.unmodifiable(warningCodes);

  final String productId;
  final String title;
  final String priceLabel;
  final String ratingLabel;
  final String durationLabel;
  final String cancellationLabel;
  final String availabilityState;
  final ActivityPhoto? photo;
  final String? distanceLabel;
  final bool stale;
  final List<String> warningCodes;

  factory ActivityResultCard.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "productId",
      "title",
      "priceLabel",
      "ratingLabel",
      "durationLabel",
      "cancellationLabel",
      "availabilityState",
      "photo",
      "distanceLabel",
      "stale",
      "warningCodes",
    });
    final value = ActivityResultCard(
      productId: ActivityCodec.text(json, 'productId', required: true)!,
      title: ActivityCodec.text(json, 'title', required: true)!,
      priceLabel: ActivityCodec.text(json, 'priceLabel', required: true)!,
      ratingLabel: ActivityCodec.text(json, 'ratingLabel', required: true)!,
      durationLabel: ActivityCodec.text(json, 'durationLabel', required: true)!,
      cancellationLabel: ActivityCodec.text(
        json,
        'cancellationLabel',
        required: true,
      )!,
      availabilityState: ActivityCodec.text(
        json,
        'availabilityState',
        required: true,
      )!,
      photo: json['photo'] == null
          ? null
          : ActivityPhoto.fromJson(ActivityCodec.object(json['photo'])),
      distanceLabel: ActivityCodec.text(json, 'distanceLabel'),
      stale: ActivityCodec.boolean(json, 'stale') ?? false,
      warningCodes:
          ActivityCodec.list(json, 'warningCodes', (v) {
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

  static ActivityResult<ActivityResultCard> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityResultCard.fromJson(ActivityCodec.object(input)),
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

  ActivityResultCard copyWith({
    Set<String> clear = const {},
    String? productId,
    String? title,
    String? priceLabel,
    String? ratingLabel,
    String? durationLabel,
    String? cancellationLabel,
    String? availabilityState,
    ActivityPhoto? photo,
    String? distanceLabel,
    bool? stale,
    List<String>? warningCodes,
  }) {
    final clearableFields = <String>{"photo", "distanceLabel"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityResultCard(
      productId: (productId ?? this.productId),
      title: (title ?? this.title),
      priceLabel: (priceLabel ?? this.priceLabel),
      ratingLabel: (ratingLabel ?? this.ratingLabel),
      durationLabel: (durationLabel ?? this.durationLabel),
      cancellationLabel: (cancellationLabel ?? this.cancellationLabel),
      availabilityState: (availabilityState ?? this.availabilityState),
      photo: clear.contains('photo') ? null : (photo ?? this.photo),
      distanceLabel: clear.contains('distanceLabel')
          ? null
          : (distanceLabel ?? this.distanceLabel),
      stale: (stale ?? this.stale),
      warningCodes: (warningCodes ?? this.warningCodes),
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
      if (title.trim().isEmpty || title.length > 4000)
        validationIssues.add(
          const ActivityIssue('title', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (priceLabel.trim().isEmpty || priceLabel.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'priceLabel',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (ratingLabel.trim().isEmpty || ratingLabel.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'ratingLabel',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (durationLabel.trim().isEmpty || durationLabel.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'durationLabel',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (cancellationLabel.trim().isEmpty || cancellationLabel.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'cancellationLabel',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (availabilityState.trim().isEmpty || availabilityState.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'availabilityState',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (photo != null) {
      for (final issue in photo!.validate())
        validationIssues.add(
          ActivityIssue(
            'photo.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (distanceLabel != null) {
      if (distanceLabel!.trim().isEmpty || distanceLabel!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'distanceLabel',
            'text',
            'Use nonempty bounded text',
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
    if (!{
      'unknown',
      'available',
      'unavailable',
      'insufficientCapacity',
      'stale',
    }.contains(availabilityState))
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
    "title": title,
    "priceLabel": priceLabel,
    "ratingLabel": ratingLabel,
    "durationLabel": durationLabel,
    "cancellationLabel": cancellationLabel,
    "availabilityState": availabilityState,
    if (photo != null) "photo": photo!.toJson(),
    if (distanceLabel != null) "distanceLabel": distanceLabel,
    "stale": stale,
    "warningCodes": warningCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityResultCard &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityResultCard(redacted)';
}
