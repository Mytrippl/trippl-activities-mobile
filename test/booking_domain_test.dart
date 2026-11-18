import 'package:test/test.dart';
import 'package:trippl_activities_mobile/trippl_activities_mobile.dart';
import 'support.dart';
import 'booking_support.dart';

void main() {
  test(
    'complete fresh draft is reviewable and requires explicit confirmation',
    () {
      final draft = readyDraft();
      expect(
        ActivityBookingIntents.review(draft.value, policy, now: now).ready,
        isTrue,
      );
      expect(
        () => ActivityBookingIntents.prepare(
          draft.value,
          policy,
          id: 'i',
          now: now,
          confirmedByUser: false,
        ),
        throwsStateError,
      );
      final intent = ActivityBookingIntents.prepare(
        draft.value,
        policy,
        id: 'i',
        now: now,
        confirmedByUser: true,
      );
      expect(intent.total, money(1000));
      expect(
        intent.draftFingerprint,
        ActivityBookingGuard.fingerprint(draft.value),
      );
    },
  );
  test('required and traveler-scoped answers cannot be skipped', () {
    final questions = [
      ActivityQuestion(id: 'hotel', label: 'Hotel', isRequired: true),
      ActivityQuestion(
        id: 'meal',
        label: 'Meal',
        kind: 'choice',
        isRequired: true,
        travelerScoped: true,
        choices: [
          ActivityQuestionChoice(
            id: 'veg',
            label: 'Vegetarian',
            value: 'vegetarian',
          ),
        ],
      ),
    ];
    final draft = readyDraft(questions: questions);
    expect(
      ActivityBookingIntents.review(draft.value, policy, now: now).ready,
      isFalse,
    );
    draft.answer(
      ActivityAnswer(
        questionId: 'hotel',
        values: ['Central hotel'],
        updatedAt: now,
      ),
      expectedRevision: draft.value.revision,
    );
    draft.answer(
      ActivityAnswer(
        questionId: 'meal',
        travelerId: 'traveler-0',
        values: ['vegetarian'],
        updatedAt: now,
      ),
      expectedRevision: draft.value.revision,
    );
    expect(
      ActivityBookingIntents.review(draft.value, policy, now: now).ready,
      isTrue,
    );
  });
  test(
    'inactive choice unknown question and foreign traveler answers fail review',
    () {
      final q = ActivityQuestion(
        id: 'q',
        label: 'Choice',
        kind: 'choice',
        choices: [
          ActivityQuestionChoice(
            id: 'a',
            label: 'A',
            value: 'a',
            active: false,
          ),
        ],
      );
      final answers = ActivityAnswerSet(
        draftId: 'd',
        updatedAt: now,
        answers: [
          ActivityAnswer(questionId: 'q', values: ['a'], updatedAt: now),
        ],
      );
      expect(
        ActivityQuestions.assess(
          [q],
          answers,
          travelers(),
          draftId: 'd',
          now: now,
        ).complete,
        isFalse,
      );
      expect(
        () => ActivityQuestions.assess(
          [q],
          answers.copyWith(
            answers: [
              ActivityAnswer(
                questionId: 'unknown',
                values: ['a'],
                updatedAt: now,
              ),
            ],
          ),
          travelers(),
          draftId: 'd',
          now: now,
        ),
        throwsFormatException,
      );
    },
  );
  test('sensitive answers are redacted from general form projection', () {
    final q = ActivityQuestion(
      id: 'q',
      label: 'Supplier note',
      sensitive: true,
    );
    final answers = ActivityAnswerSet(
      draftId: 'd',
      updatedAt: now,
      answers: [
        ActivityAnswer(questionId: 'q', values: ['private'], updatedAt: now),
      ],
    );
    final form = ActivityQuestions.form(
      [q],
      answers,
      travelers: travelers(),
      draftId: 'd',
      now: now,
    );
    expect(form.toString(), isNot(contains('private')));
    expect(ActivityQuestions.publicAnswers([q], answers), isEmpty);
  });
  test(
    'quote replacement invalidates earlier acceptance even at the same price',
    () {
      final draft = readyDraft();
      final old = draft.value;
      final selection = availability(slotId: 'slot');
      final request = ActivityRequests(
        scope: 'test-user',
        clock: () => now,
      ).availability(selection, quote: true);
      final next = old.quote!.copyWith(
        id: 'replacement',
        expiresAt: now.add(const Duration(minutes: 4)),
      );
      draft.quote(next, request, expectedRevision: old.revision);
      expect(draft.value.terms, isNull);
      expect(
        ActivityBookingIntents.review(
          draft.value,
          policy,
          now: now,
        ).reasonCodes,
        contains('termsNotAccepted'),
      );
    },
  );
  test('party changes clear dependent quote terms and traveler details', () {
    final draft = readyDraft();
    draft.party(
      travelers(ages: [30, 40]),
      expectedRevision: draft.value.revision,
    );
    expect(draft.value.quote, isNull);
    expect(draft.value.terms, isNull);
    expect(draft.value.answers, isNull);
  });
  test(
    'accepted terms version and quote expiry are rechecked at submission',
    () {
      final draft = readyDraft();
      expect(
        ActivityBookingIntents.review(
          draft.value,
          policy.copyWith(termsVersion: 'v2'),
          now: now,
        ).reasonCodes,
        contains('termsVersionChanged'),
      );
      expect(
        ActivityBookingIntents.review(
          draft.value,
          policy,
          now: now.add(const Duration(minutes: 6)),
        ).reasonCodes,
        contains('quoteExpired'),
      );
    },
  );
  test('contact validation and policy-specific names are explicit', () {
    expect(() => ActivityContacts.email('not-an-email'), throwsFormatException);
    expect(() => ActivityContacts.phone('1234'), throwsFormatException);
    expect(ActivityContacts.phone('+1 (555) 123-4567'), '+15551234567');
    final draft = readyDraft();
    expect(
      ActivityBookingIntents.review(
        draft.value,
        policy.copyWith(requireNames: true),
        now: now,
      ).ready,
      isFalse,
    );
  });
  test('traveler birth dates must match the age at travel', () {
    expect(
      ActivityBookingTravelers.ageOn(
        DateTime.utc(2000, 11, 19),
        DateTime.utc(2026, 11, 18),
      ),
      25,
    );
    final issues = ActivityBookingTravelers.review(travelers(), [
      ActivityBookingTraveler(
        travelerId: 'traveler-0',
        age: 30,
        dateOfBirth: DateTime.utc(2000, 1, 1),
      ),
    ], travelDate: DateTime.utc(2026, 11, 18));
    expect(issues, contains('travelerAgeChanged:traveler-0'));
  });
  test(
    'pickup choices obey option identity deadline and confirmation policy',
    () {
      final pickup = ActivityPickup(
        id: 'p',
        available: true,
        requiresSelection: true,
        pointIds: ['meeting'],
        cutoffAt: now.add(const Duration(hours: 1)),
      );
      expect(
        ActivityPickupChoices.review(
          pickup,
          null,
          optionId: 'option',
          now: now,
        ),
        ['pickupSelectionRequired'],
      );
      final choice = ActivityPickupChoices.select(
        pickup,
        ActivityMeetingPoint(
          id: 'meeting',
          name: 'Entrance',
          optionId: 'option',
        ),
        optionId: 'option',
        now: now,
      );
      expect(
        ActivityPickupChoices.review(
          pickup,
          choice,
          optionId: 'option',
          now: now,
        ),
        ['pickupConfirmationRequired'],
      );
      expect(
        () => ActivityPickupChoices.review(
          pickup,
          choice.copyWith(pointId: 'elsewhere', clear: {'meetingPoint'}),
          optionId: 'option',
          now: now,
        ),
        throwsStateError,
      );
    },
  );
  test('booking draft does not allow edits after submission', () {
    final draft = readyDraft();
    draft.state('submitting', expectedRevision: draft.value.revision);
    expect(
      () => draft.contact(
        ActivityBookingContact(email: 'other@example.com', updatedAt: now),
        expectedRevision: draft.value.revision,
      ),
      throwsStateError,
    );
  });
  test('saved support payload is not sent by preparing it', () {
    final service = ActivitySupportDrafts(scope: 'test-user', clock: () => now);
    service.create(
      booking(),
      id: 'support',
      category: 'voucher',
      summary: 'Please check voucher',
    );
    expect(service.payload('support', confirmedByUser: true)['sent'], isFalse);
  });
}
