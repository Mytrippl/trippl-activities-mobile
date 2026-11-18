enum ActivitySeverity { error, warning, information }

class ActivityIssue {
  const ActivityIssue(
    this.field,
    this.code,
    this.message, {
    this.severity = ActivitySeverity.error,
  });
  final String field, code, message;
  final ActivitySeverity severity;
  Map<String, Object?> toJson() => {
    'field': field,
    'code': code,
    'message': message,
    'severity': severity.name,
  };
  @override
  bool operator ==(Object other) =>
      other is ActivityIssue &&
      other.field == field &&
      other.code == code &&
      other.message == message &&
      other.severity == severity;
  @override
  int get hashCode => Object.hash(field, code, message, severity);
  @override
  String toString() => '$field: $message';
}

class ActivityValidationException implements Exception {
  ActivityValidationException(Iterable<ActivityIssue> issues)
    : issues = List.unmodifiable(issues);
  final List<ActivityIssue> issues;
  @override
  String toString() => issues.map((i) => i.message).join('; ');
}

class ActivityResult<T> {
  ActivityResult({this.value, Iterable<ActivityIssue> issues = const []})
    : issues = List.unmodifiable(issues);
  final T? value;
  final List<ActivityIssue> issues;
  bool get isSuccess =>
      value != null && !issues.any((i) => i.severity == ActivitySeverity.error);
  T require() {
    if (!isSuccess) throw ActivityValidationException(issues);
    return value as T;
  }

  ActivityResult<R> map<R>(R Function(T value) transform) => isSuccess
      ? ActivityResult(value: transform(value as T), issues: issues)
      : ActivityResult(issues: issues);
}
