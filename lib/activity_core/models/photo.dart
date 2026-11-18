// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'attribution.dart';

class ActivityPhoto {
  ActivityPhoto({
    required this.id,
    required this.url,
    this.width,
    this.height,
    this.caption,
    this.observedAt,
    this.expiresAt,
    List<ActivityAttribution> attributions = const [],
  }) : attributions = List.unmodifiable(attributions);

  final String id;
  final String url;
  final int? width;
  final int? height;
  final String? caption;
  final DateTime? observedAt;
  final DateTime? expiresAt;
  final List<ActivityAttribution> attributions;

  factory ActivityPhoto.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "url",
      "width",
      "height",
      "caption",
      "observedAt",
      "expiresAt",
      "attributions",
    });
    final value = ActivityPhoto(
      id: ActivityCodec.text(json, 'id', required: true)!,
      url: ActivityCodec.text(json, 'url', required: true)!,
      width: ActivityCodec.integer(
        json,
        'width',
        minimum: 0,
        maximum: 9000000000000,
      ),
      height: ActivityCodec.integer(
        json,
        'height',
        minimum: 0,
        maximum: 9000000000000,
      ),
      caption: ActivityCodec.text(json, 'caption'),
      observedAt: ActivityCodec.date(json, 'observedAt'),
      expiresAt: ActivityCodec.date(json, 'expiresAt'),
      attributions:
          ActivityCodec.list(
            json,
            'attributions',
            (v) => ActivityAttribution.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityPhoto> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityPhoto.fromJson(ActivityCodec.object(input)),
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

  ActivityPhoto copyWith({
    Set<String> clear = const {},
    String? id,
    String? url,
    int? width,
    int? height,
    String? caption,
    DateTime? observedAt,
    DateTime? expiresAt,
    List<ActivityAttribution>? attributions,
  }) {
    final clearableFields = <String>{
      "width",
      "height",
      "caption",
      "observedAt",
      "expiresAt",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityPhoto(
      id: (id ?? this.id),
      url: (url ?? this.url),
      width: clear.contains('width') ? null : (width ?? this.width),
      height: clear.contains('height') ? null : (height ?? this.height),
      caption: clear.contains('caption') ? null : (caption ?? this.caption),
      observedAt: clear.contains('observedAt')
          ? null
          : (observedAt ?? this.observedAt),
      expiresAt: clear.contains('expiresAt')
          ? null
          : (expiresAt ?? this.expiresAt),
      attributions: (attributions ?? this.attributions),
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
      if (url.trim().isEmpty || url.length > 4000)
        validationIssues.add(
          const ActivityIssue('url', 'text', 'Use nonempty bounded text'),
        );
    }
    if (width != null) {
      if (width! < 0 || width! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'width',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (height != null) {
      if (height! < 0 || height! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'height',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (caption != null) {
      if (caption!.trim().isEmpty || caption!.length > 4000)
        validationIssues.add(
          const ActivityIssue('caption', 'text', 'Use nonempty bounded text'),
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
    if (Uri.tryParse(url)?.scheme != 'https' ||
        Uri.tryParse(url)!.host.isEmpty ||
        Uri.tryParse(url)!.userInfo.isNotEmpty ||
        width != null && (width! < 1 || width! > 20000) ||
        height != null && (height! < 1 || height! > 20000) ||
        observedAt != null &&
            expiresAt != null &&
            !expiresAt!.isAfter(observedAt!))
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
    "url": url,
    if (width != null) "width": width,
    if (height != null) "height": height,
    if (caption != null) "caption": caption,
    if (observedAt != null) "observedAt": observedAt!.toUtc().toIso8601String(),
    if (expiresAt != null) "expiresAt": expiresAt!.toUtc().toIso8601String(),
    "attributions": attributions.map((item) => item.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityPhoto && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityPhoto(redacted)';
}
