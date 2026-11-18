// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivitySyncConflict {
  ActivitySyncConflict({
    required this.id,
    required this.resourceId,
    required this.localDigest,
    required this.remoteDigest,
    required this.remoteRevision,
    required this.detectedAt,
    this.resolution = "unresolved",
    List<String> fieldNames = const [],
  }) : fieldNames = List.unmodifiable(fieldNames);

  final String id;
  final String resourceId;
  final String localDigest;
  final String remoteDigest;
  final int remoteRevision;
  final DateTime detectedAt;
  final String resolution;
  final List<String> fieldNames;

  factory ActivitySyncConflict.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "resourceId",
      "localDigest",
      "remoteDigest",
      "remoteRevision",
      "detectedAt",
      "resolution",
      "fieldNames",
    });
    final value = ActivitySyncConflict(
      id: ActivityCodec.text(json, 'id', required: true)!,
      resourceId: ActivityCodec.text(json, 'resourceId', required: true)!,
      localDigest: ActivityCodec.text(json, 'localDigest', required: true)!,
      remoteDigest: ActivityCodec.text(json, 'remoteDigest', required: true)!,
      remoteRevision: ActivityCodec.integer(
        json,
        'remoteRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      detectedAt: ActivityCodec.date(json, 'detectedAt', required: true)!,
      resolution: ActivityCodec.text(json, 'resolution') ?? "unresolved",
      fieldNames:
          ActivityCodec.list(json, 'fieldNames', (v) {
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

  static ActivityResult<ActivitySyncConflict> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivitySyncConflict.fromJson(ActivityCodec.object(input)),
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

  ActivitySyncConflict copyWith({
    Set<String> clear = const {},
    String? id,
    String? resourceId,
    String? localDigest,
    String? remoteDigest,
    int? remoteRevision,
    DateTime? detectedAt,
    String? resolution,
    List<String>? fieldNames,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivitySyncConflict(
      id: (id ?? this.id),
      resourceId: (resourceId ?? this.resourceId),
      localDigest: (localDigest ?? this.localDigest),
      remoteDigest: (remoteDigest ?? this.remoteDigest),
      remoteRevision: (remoteRevision ?? this.remoteRevision),
      detectedAt: (detectedAt ?? this.detectedAt),
      resolution: (resolution ?? this.resolution),
      fieldNames: (fieldNames ?? this.fieldNames),
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
      if (resourceId.trim().isEmpty || resourceId.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'resourceId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (localDigest.trim().isEmpty || localDigest.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'localDigest',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (remoteDigest.trim().isEmpty || remoteDigest.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'remoteDigest',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (remoteRevision < 0 || remoteRevision > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'remoteRevision',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (resolution.trim().isEmpty || resolution.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'resolution',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (fieldNames.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'fieldNames',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (fieldNames.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'fieldNames',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (remoteRevision < 1 ||
        !{
          'unresolved',
          'keepLocal',
          'keepRemote',
          'manual',
        }.contains(resolution) ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(localDigest) ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(remoteDigest))
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
    "resourceId": resourceId,
    "localDigest": localDigest,
    "remoteDigest": remoteDigest,
    "remoteRevision": remoteRevision,
    "detectedAt": detectedAt.toUtc().toIso8601String(),
    "resolution": resolution,
    "fieldNames": fieldNames,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivitySyncConflict &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivitySyncConflict(redacted)';
}
