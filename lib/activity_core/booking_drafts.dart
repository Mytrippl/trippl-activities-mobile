import '../trippl_activities_mobile.dart';

class ActivityBookingDrafts {
  ActivityBookingDrafts(ActivityBookingDraft draft, {required this.clock})
    : _value = draft {
    ActivityBookingGuard.draft(draft, scope: draft.scope, now: clock());
  }
  final DateTime Function() clock;
  ActivityBookingDraft _value;
  ActivityBookingDraft get value => _value;
  static ActivityBookingDraft create({
    required String id,
    required String scope,
    required ActivityProduct product,
    required ActivitySlot slot,
    required ActivityAvailabilityRequest selection,
    required int offsetMinutes,
    required DateTime now,
    List<ActivityQuestion> questions = const [],
  }) {
    if (product.id != selection.productId ||
        slot.id != selection.selectedSlotId ||
        slot.optionId != selection.optionId)
      throw StateError('Draft input differs from selected activity');
    final value = ActivityBookingDraft(
      id: id,
      scope: scope,
      product: product,
      optionId: selection.optionId,
      slot: slot,
      travelDate: selection.travelDate,
      travelers: selection.travelers,
      createdAt: now,
      updatedAt: now,
      questions: questions,
      units: selection.units,
      offsetMinutes: offsetMinutes,
      languageCode: selection.selectedLanguage,
    );
    ActivityBookingGuard.draft(value, scope: scope, now: now);
    return value;
  }

  void _edit(int expectedRevision) {
    ActivityGuard.revision(_value.revision, expectedRevision);
    if (!{'editing', 'review'}.contains(_value.state))
      throw StateError('Draft cannot be edited after submission');
  }

  void _replace(ActivityBookingDraft next) {
    ActivityBookingGuard.draft(next, scope: _value.scope, now: clock());
    _value = next;
  }

  void contact(
    ActivityBookingContact contact, {
    required int expectedRevision,
  }) {
    _edit(expectedRevision);
    final normalized = ActivityContacts.normalize(contact, now: clock());
    _replace(
      _value.copyWith(
        contact: normalized,
        state: 'editing',
        updatedAt: clock(),
        revision: _value.revision + 1,
      ),
    );
  }

  void traveler(
    ActivityBookingTraveler traveler, {
    required int expectedRevision,
  }) {
    _edit(expectedRevision);
    final old = _value.travelerDetails
        .where((t) => t.travelerId == traveler.travelerId)
        .firstOrNull;
    final details = ActivityBookingTravelers.replace(
      _value.travelerDetails,
      traveler,
      party: _value.travelers,
      travelDate: _value.travelDate,
      expectedRevision: old?.revision ?? 0,
    );
    _replace(
      _value.copyWith(
        travelerDetails: details,
        state: 'editing',
        updatedAt: clock(),
        revision: _value.revision + 1,
      ),
    );
  }

  void answer(ActivityAnswer answer, {required int expectedRevision}) {
    _edit(expectedRevision);
    final next = ActivityQuestions.put(
      _value.answers,
      answer,
      draftId: _value.id,
      questions: _value.questions,
      travelers: _value.travelers,
      now: clock(),
      expectedRevision: _value.answers?.revision ?? 0,
    );
    _replace(
      _value.copyWith(
        answers: next,
        state: 'editing',
        updatedAt: clock(),
        revision: _value.revision + 1,
      ),
    );
  }

  void questions(
    List<ActivityQuestion> questions, {
    required int expectedRevision,
  }) {
    _edit(expectedRevision);
    ActivityQuestions.revision(questions);
    _replace(
      _value.copyWith(
        questions: questions,
        clear: {'answers', 'terms'},
        state: 'editing',
        updatedAt: clock(),
        revision: _value.revision + 1,
      ),
    );
  }

  void pickup(
    ActivityPickup? policy,
    ActivityPickupChoice? choice, {
    required int expectedRevision,
  }) {
    _edit(expectedRevision);
    ActivityPickupChoices.review(
      policy,
      choice,
      optionId: _value.optionId,
      now: clock(),
      requireConfirmation: false,
    );
    _replace(
      _value.copyWith(
        pickup: choice,
        clear: {'terms', if (choice == null) 'pickup'},
        state: 'editing',
        updatedAt: clock(),
        revision: _value.revision + 1,
      ),
    );
  }

  void party(
    ActivityTravelerMix travelers, {
    required int expectedRevision,
    int? units,
  }) {
    _edit(expectedRevision);
    ActivityGuard.record(travelers.validate());
    _replace(
      _value.copyWith(
        travelers: travelers,
        units: units,
        travelerDetails: [],
        clear: {'answers', 'quote', 'quoteRequestFingerprint', 'terms'},
        state: 'editing',
        updatedAt: clock(),
        revision: _value.revision + 1,
      ),
    );
  }

  ActivityQuoteChange quote(
    ActivityPriceQuote quote,
    ActivityProviderRequest request, {
    required int expectedRevision,
  }) {
    _edit(expectedRevision);
    final change = ActivityQuoteReview.compare(_value, quote, now: clock());
    final next = ActivityQuoteReview.bind(_value, quote, request, now: clock());
    _replace(
      next.copyWith(
        state: 'review',
        updatedAt: clock(),
        revision: _value.revision + 1,
      ),
    );
    return change;
  }

  void acceptTerms({
    required String id,
    required String termsVersion,
    required bool accepted,
    required int expectedRevision,
  }) {
    _edit(expectedRevision);
    final terms = ActivityBookingTerms.accept(
      _value,
      id: id,
      termsVersion: termsVersion,
      accepted: accepted,
      now: clock(),
    );
    _replace(
      _value.copyWith(
        terms: terms,
        state: 'review',
        updatedAt: clock(),
        revision: _value.revision + 1,
      ),
    );
  }

  void state(String state, {required int expectedRevision}) {
    ActivityGuard.revision(_value.revision, expectedRevision);
    const transitions = {
      'editing': {'review', 'abandoned'},
      'review': {'editing', 'submitting', 'abandoned'},
      'submitting': {'pending', 'confirmed', 'rejected', 'unknown'},
      'pending': {'confirmed', 'rejected', 'unknown'},
      'unknown': {'pending', 'confirmed', 'rejected'},
      'rejected': <String>{},
      'confirmed': <String>{},
      'abandoned': <String>{},
    };
    if (!(transitions[_value.state] ?? {}).contains(state))
      throw StateError('Invalid booking draft transition');
    _replace(
      _value.copyWith(
        state: state,
        updatedAt: clock(),
        revision: _value.revision + 1,
      ),
    );
  }
}
