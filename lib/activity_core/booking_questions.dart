import '../trippl_activities_mobile.dart';

class ActivityQuestionReview {
  ActivityQuestionReview(List<String> reasons)
    : reasonCodes = List.unmodifiable(reasons);
  final List<String> reasonCodes;
  bool get complete => reasonCodes.isEmpty;
}

class ActivityQuestions {
  static int revision(List<ActivityQuestion> questions) {
    if (questions.length > 100)
      throw const FormatException('Too many activity booking questions');
    ActivityGuard.distinct(questions.map((q) => q.id));
    var highest = 1;
    for (final q in questions) {
      ActivityGuard.record(q.validate());
      if (q.revision > highest) highest = q.revision;
    }
    return highest;
  }

  static ActivityQuestionReview assess(
    List<ActivityQuestion> questions,
    ActivityAnswerSet? answers,
    ActivityTravelerMix travelers, {
    required String draftId,
    required DateTime now,
  }) {
    final expected = revision(questions);
    ActivityGuard.record(travelers.validate());
    final reasons = <String>[];
    if (answers != null) {
      ActivityGuard.record(answers.validate());
      if (answers.draftId != draftId || answers.updatedAt.isAfter(now))
        throw StateError('Answer set parent or clock mismatch');
      if (answers.questionRevision != expected)
        reasons.add('questionRevisionChanged');
    }
    final rows = answers?.answers ?? const <ActivityAnswer>[];
    final seen = <String>{};
    for (final answer in rows) {
      ActivityGuard.record(answer.validate());
      final key = '${answer.questionId}:${answer.travelerId ?? ''}';
      if (!seen.add(key))
        throw const FormatException('Question answer identity repeats');
      final question = questions
          .where((q) => q.id == answer.questionId)
          .firstOrNull;
      if (question == null)
        throw const FormatException('Unknown supplier question');
      if (question.travelerScoped != (answer.travelerId != null) ||
          answer.travelerId != null &&
              !travelers.travelers.any((t) => t.id == answer.travelerId))
        throw StateError('Question traveler scope mismatch');
      if (answer.updatedAt.isAfter(now))
        throw const FormatException('Answer timestamp is in the future');
      reasons.addAll(_values(question, answer.values));
    }
    for (final q in questions.where((q) => q.isRequired)) {
      final ids = q.travelerScoped
          ? travelers.travelers.map((t) => t.id).toList()
          : <String?>[null];
      for (final id in ids)
        if (!rows.any(
          (a) =>
              a.questionId == q.id && a.travelerId == id && a.values.isNotEmpty,
        ))
          reasons.add('requiredAnswerMissing:${q.id}');
    }
    return ActivityQuestionReview(reasons.toSet().toList());
  }

  static List<String> _values(ActivityQuestion question, List<String> values) {
    if (values.isEmpty)
      return question.isRequired
          ? ['requiredAnswerMissing:${question.id}']
          : [];
    if (question.kind != 'multiChoice' && values.length != 1)
      return ['answerCardinality:${question.id}'];
    if (values.any(
      (v) =>
          v.trim().isEmpty ||
          v.length > question.maximumLength ||
          RegExp(r'[\x00-\x1f]').hasMatch(v),
    ))
      return ['invalidAnswerText:${question.id}'];
    if (question.kind == 'choice' || question.kind == 'multiChoice') {
      if (values.any(
        (v) => !question.choices.any((c) => c.active && c.value == v),
      ))
        return ['answerChoiceUnavailable:${question.id}'];
    } else if (question.kind == 'integer') {
      final number = int.tryParse(values.single);
      if (number == null ||
          number < 0 ||
          question.minimumNumber != null && number < question.minimumNumber! ||
          question.maximumNumber != null && number > question.maximumNumber!)
        return ['answerNumberRange:${question.id}'];
    } else if (question.kind == 'boolean' &&
        !{'true', 'false'}.contains(values.single))
      return ['answerBoolean:${question.id}'];
    else if (question.kind == 'date') {
      try {
        ActivityCodec.date(
          {'date': values.single},
          'date',
          required: true,
          calendar: true,
        );
      } catch (_) {
        return ['answerDate:${question.id}'];
      }
    }
    return [];
  }

  static ActivityAnswerSet put(
    ActivityAnswerSet? old,
    ActivityAnswer answer, {
    required String draftId,
    required List<ActivityQuestion> questions,
    required ActivityTravelerMix travelers,
    required DateTime now,
    required int expectedRevision,
  }) {
    ActivityGuard.revision(old?.revision ?? 0, expectedRevision);
    final rows =
        (old?.answers ?? const <ActivityAnswer>[])
            .where(
              (a) =>
                  a.questionId != answer.questionId ||
                  a.travelerId != answer.travelerId,
            )
            .toList()
          ..add(answer);
    final next = ActivityAnswerSet(
      draftId: draftId,
      updatedAt: now,
      answers: rows,
      questionRevision: revision(questions),
      revision: expectedRevision + 1,
    );
    assess(questions, next, travelers, draftId: draftId, now: now);
    return next;
  }

  static List<ActivityAnswer> publicAnswers(
    List<ActivityQuestion> questions,
    ActivityAnswerSet? answers,
  ) => List.unmodifiable(
    (answers?.answers ?? const <ActivityAnswer>[]).where(
      (a) => questions.any((q) => q.id == a.questionId && !q.sensitive),
    ),
  );
  static List<Map<String, Object?>> form(
    List<ActivityQuestion> questions,
    ActivityAnswerSet? answers, {
    required ActivityTravelerMix travelers,
    required String draftId,
    required DateTime now,
    bool showSensitiveAnswers = false,
  }) {
    final review = assess(
      questions,
      answers,
      travelers,
      draftId: draftId,
      now: now,
    );
    return List.unmodifiable([
      for (final question in questions)
        Map<String, Object?>.unmodifiable({
          'id': question.id,
          'label': question.label,
          'kind': question.kind,
          'required': question.isRequired,
          'travelerScoped': question.travelerScoped,
          'sensitive': question.sensitive,
          'maximumLength': question.maximumLength,
          'choices': question.choices
              .where((choice) => choice.active)
              .map(
                (choice) => {
                  'id': choice.id,
                  'label': choice.label,
                  'value': choice.value,
                },
              )
              .toList(),
          'answers': [
            for (final answer in answers?.answers ?? const <ActivityAnswer>[])
              if (answer.questionId == question.id)
                {
                  'travelerId': answer.travelerId,
                  'revision': answer.revision,
                  'redacted': question.sensitive && !showSensitiveAnswers,
                  if (!question.sensitive || showSensitiveAnswers)
                    'values': answer.values,
                },
          ],
          'reasonCodes': review.reasonCodes
              .where((reason) => reason.endsWith(':${question.id}'))
              .toList(),
        }),
    ]);
  }
}
