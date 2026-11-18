import 'dart:convert';
import 'package:test/test.dart';
import 'package:trippl_activities_mobile/trippl_activities_mobile.dart';

void main() {
  test(
    'ActivityQuestionChoice round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"label\": \"example\", \"value\": \"example\", \"active\": true, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityQuestionChoice.fromJson(json);
      expect(ActivityQuestionChoice.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityQuestionChoice.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityQuestion round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"label\": \"example\", \"kind\": \"text\", \"isRequired\": false, \"travelerScoped\": false, \"sensitive\": false, \"choices\": [], \"maximumLength\": 200, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityQuestion.fromJson(json);
      expect(ActivityQuestion.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityQuestion.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityAnswer round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"questionId\": \"example\", \"values\": [], \"revision\": 1, \"updatedAt\": \"2026-11-18T12:00:00.000Z\"}",
              )
              as Map<String, dynamic>;
      final value = ActivityAnswer.fromJson(json);
      expect(ActivityAnswer.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityAnswer.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityAnswerSet round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"draftId\": \"example\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"answers\": [], \"questionRevision\": 1, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityAnswerSet.fromJson(json);
      expect(ActivityAnswerSet.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityAnswerSet.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityBookingContact round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"email\": \"guest@example.com\", \"language\": \"en\", \"revision\": 1, \"updatedAt\": \"2026-11-18T12:00:00.000Z\"}",
              )
              as Map<String, dynamic>;
      final value = ActivityBookingContact.fromJson(json);
      expect(ActivityBookingContact.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityBookingContact.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityBookingTraveler round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"travelerId\": \"example\", \"age\": 30, \"lead\": false, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityBookingTraveler.fromJson(json);
      expect(ActivityBookingTraveler.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityBookingTraveler.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityPickupChoice round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"pickupId\": \"example\", \"pointId\": \"example\", \"confirmed\": false, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityPickupChoice.fromJson(json);
      expect(ActivityPickupChoice.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityPickupChoice.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityTermsAcceptance round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"draftId\": \"example\", \"termsVersion\": \"v1\", \"acceptedAt\": \"2026-11-18T12:00:00.000Z\", \"quoteDigest\": \"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\", \"accepted\": false, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityTermsAcceptance.fromJson(json);
      expect(ActivityTermsAcceptance.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityTermsAcceptance.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityBookingDraft round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"product\": {\"id\": \"product\", \"title\": \"Museum tour\"}, \"optionId\": \"option\", \"slot\": {\"id\": \"slot\", \"productId\": \"product\", \"optionId\": \"option\", \"startsAt\": \"2026-11-18T14:00:00.000Z\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T13:00:00.000Z\"}, \"travelDate\": \"2026-11-18\", \"travelers\": {\"travelers\": [], \"minimumTravelers\": 1, \"maximumTravelers\": 100, \"pricingBasis\": \"perPerson\", \"revision\": 1}, \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"travelerDetails\": [], \"questions\": [], \"state\": \"editing\", \"units\": 1, \"revision\": 1, \"offsetMinutes\": 0}",
              )
              as Map<String, dynamic>;
      final value = ActivityBookingDraft.fromJson(json);
      expect(ActivityBookingDraft.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityBookingDraft.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityBookingIntent round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"draftId\": \"example\", \"draftFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"quoteId\": \"example\", \"total\": {\"currency\": \"USD\", \"amountMinor\": 1, \"decimals\": 2}, \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T15:00:00.000Z\", \"idempotencyKey\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"state\": \"prepared\", \"attempts\": 0, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityBookingIntent.fromJson(json);
      expect(ActivityBookingIntent.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityBookingIntent.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityBookingReceipt round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"intentId\": \"example\", \"scope\": \"test-user\", \"draftFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"receivedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"pending\", \"revision\": 1, \"warningCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivityBookingReceipt.fromJson(json);
      expect(ActivityBookingReceipt.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityBookingReceipt.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityBookingStatus round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"bookingId\": \"booking\", \"scope\": \"test-user\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"pending\", \"revision\": 1, \"warningCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivityBookingStatus.fromJson(json);
      expect(ActivityBookingStatus.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityBookingStatus.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityBookingRecord round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"productId\": \"product\", \"optionId\": \"option\", \"slotId\": \"slot\", \"startsAt\": \"2026-11-18T12:00:00.000Z\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"total\": {\"currency\": \"USD\", \"amountMinor\": 1, \"decimals\": 2}, \"state\": \"pending\", \"intentId\": \"example\", \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityBookingRecord.fromJson(json);
      expect(ActivityBookingRecord.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityBookingRecord.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityBookingEvent round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"bookingId\": \"booking\", \"kind\": \"pending\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\", \"revision\": 1, \"reasonCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivityBookingEvent.fromJson(json);
      expect(ActivityBookingEvent.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityBookingEvent.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityReconciliation round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"bookingId\": \"booking\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"previousState\": \"pending\", \"nextState\": \"confirmed\", \"accepted\": false, \"reasonCodes\": [], \"requiresReview\": true, \"remoteRevision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityReconciliation.fromJson(json);
      expect(ActivityReconciliation.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityReconciliation.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityConfirmationPolicy round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"termsVersion\": \"v1\", \"requireNames\": false, \"requirePhone\": false, \"requirePickupConfirmation\": true, \"maximumQuoteAgeSeconds\": 900, \"maximumAttempts\": 2, \"version\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityConfirmationPolicy.fromJson(json);
      expect(ActivityConfirmationPolicy.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityConfirmationPolicy.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityQuoteChange round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"draftId\": \"example\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"oldTotal\": {\"currency\": \"USD\", \"amountMinor\": 1, \"decimals\": 2}, \"newTotal\": {\"currency\": \"USD\", \"amountMinor\": 1, \"decimals\": 2}, \"amountChanged\": false, \"currencyChanged\": false, \"selectionChanged\": false, \"requiresAcceptance\": true, \"reasonCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivityQuoteChange.fromJson(json);
      expect(ActivityQuoteChange.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityQuoteChange.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityVoucherDocument round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"bookingId\": \"booking\", \"kind\": \"text\", \"attributions\": [], \"revision\": 1, \"text\": \"Supplier voucher instructions\"}",
              )
              as Map<String, dynamic>;
      final value = ActivityVoucherDocument.fromJson(json);
      expect(ActivityVoucherDocument.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityVoucherDocument.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityVoucher round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"bookingId\": \"booking\", \"issuedAt\": \"2026-11-18T12:00:00.000Z\", \"validFrom\": \"2026-11-18T12:00:00.000Z\", \"validUntil\": \"2026-11-18T15:00:00.000Z\", \"documents\": [], \"instructions\": [], \"revision\": 1, \"revoked\": false}",
              )
              as Map<String, dynamic>;
      final value = ActivityVoucher.fromJson(json);
      expect(ActivityVoucher.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityVoucher.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityVoucherAccess round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"voucherId\": \"example\", \"bookingId\": \"booking\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"allowed\": false, \"reasonCodes\": [], \"offline\": false, \"requiresProviderVerification\": true}",
              )
              as Map<String, dynamic>;
      final value = ActivityVoucherAccess.fromJson(json);
      expect(ActivityVoucherAccess.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityVoucherAccess.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityCancellationRequest round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"bookingId\": \"booking\", \"expectedRevision\": 1, \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"idempotencyKey\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"reasonCode\": \"plansChanged\", \"confirmedByUser\": false}",
              )
              as Map<String, dynamic>;
      final value = ActivityCancellationRequest.fromJson(json);
      expect(ActivityCancellationRequest.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityCancellationRequest.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityCancellationResult round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"requestId\": \"example\", \"scope\": \"test-user\", \"bookingId\": \"booking\", \"receivedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"pending\", \"revision\": 1, \"warningCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivityCancellationResult.fromJson(json);
      expect(ActivityCancellationResult.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityCancellationResult.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityRefundEstimate round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"bookingId\": \"booking\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"assessment\": {\"policyId\": \"example\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"unknown\", \"requiresReview\": true, \"warningCodes\": []}, \"paid\": {\"currency\": \"USD\", \"amountMinor\": 1, \"decimals\": 2}, \"indicative\": true, \"requiresProviderConfirmation\": true, \"reasonCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivityRefundEstimate.fromJson(json);
      expect(ActivityRefundEstimate.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityRefundEstimate.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityRefundRecord round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"bookingId\": \"booking\", \"amount\": {\"currency\": \"USD\", \"amountMinor\": 1, \"decimals\": 2}, \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"pending\", \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityRefundRecord.fromJson(json);
      expect(ActivityRefundRecord.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityRefundRecord.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivitySupportCase round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"bookingId\": \"booking\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"category\": \"booking\", \"summary\": \"Please review this activity\", \"state\": \"draft\", \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivitySupportCase.fromJson(json);
      expect(ActivitySupportCase.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivitySupportCase.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivitySavedActivity round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"product\": {\"id\": \"product\", \"title\": \"Museum tour\"}, \"savedAt\": \"2026-11-18T12:00:00.000Z\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"priority\": 0, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivitySavedActivity.fromJson(json);
      expect(ActivitySavedActivity.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivitySavedActivity.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityCollection round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"title\": \"Activity\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"itemIds\": [], \"archived\": false, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityCollection.fromJson(json);
      expect(ActivityCollection.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityCollection.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityCollectionItem round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"collectionId\": \"example\", \"savedActivityId\": \"example\", \"addedAt\": \"2026-11-18T12:00:00.000Z\", \"position\": 0, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityCollectionItem.fromJson(json);
      expect(ActivityCollectionItem.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityCollectionItem.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityItinerary round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"title\": \"Activity\", \"startDate\": \"2026-11-18\", \"endDate\": \"2026-11-18\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"dayIds\": [], \"revision\": 1, \"state\": \"draft\"}",
              )
              as Map<String, dynamic>;
      final value = ActivityItinerary.fromJson(json);
      expect(ActivityItinerary.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityItinerary.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityItineraryDay round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"itineraryId\": \"example\", \"date\": \"2026-11-18\", \"offsetMinutes\": 0, \"stopIds\": [], \"startMinute\": 480, \"endMinute\": 1320, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityItineraryDay.fromJson(json);
      expect(ActivityItineraryDay.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityItineraryDay.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityItineraryStop round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"dayId\": \"example\", \"product\": {\"id\": \"product\", \"title\": \"Museum tour\"}, \"startsAt\": \"2026-11-18T12:00:00.000Z\", \"endsAt\": \"2026-11-18T15:00:00.000Z\", \"arrivalBufferMinutes\": 0, \"transferMinutes\": 0, \"revision\": 1, \"confirmed\": false}",
              )
              as Map<String, dynamic>;
      final value = ActivityItineraryStop.fromJson(json);
      expect(ActivityItineraryStop.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityItineraryStop.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityItineraryConflict round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"code\": \"reviewNeeded\", \"dayId\": \"example\", \"stopId\": \"example\", \"message\": \"example\", \"severity\": \"warning\", \"requiresReview\": true}",
              )
              as Map<String, dynamic>;
      final value = ActivityItineraryConflict.fromJson(json);
      expect(ActivityItineraryConflict.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityItineraryConflict.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityReminder round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"resourceId\": \"example\", \"dueAt\": \"2026-11-18T15:00:00.000Z\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"leadMinutes\": 30, \"enabled\": false, \"delivered\": false, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityReminder.fromJson(json);
      expect(ActivityReminder.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityReminder.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityNotification round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"resourceId\": \"example\", \"kind\": \"booking\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T15:00:00.000Z\", \"read\": false, \"dismissed\": false, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityNotification.fromJson(json);
      expect(ActivityNotification.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityNotification.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityPreference round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"scope\": \"test-user\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"language\": \"en\", \"currency\": \"USD\", \"hideSaved\": false, \"offlineEnabled\": false, \"sortField\": \"recommended\", \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityPreference.fromJson(json);
      expect(ActivityPreference.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityPreference.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityPrivacy round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"scope\": \"test-user\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"retainHistory\": false, \"persistDraftDetails\": false, \"allowAnalytics\": false, \"retentionDays\": 30, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityPrivacy.fromJson(json);
      expect(ActivityPrivacy.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityPrivacy.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityConsent round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"purpose\": \"history\", \"policyVersion\": \"v1\", \"recordedAt\": \"2026-11-18T12:00:00.000Z\", \"granted\": false, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityConsent.fromJson(json);
      expect(ActivityConsent.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityConsent.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityHistoryEntry round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"kind\": \"search\", \"resourceId\": \"example\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\", \"count\": 1, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityHistoryEntry.fromJson(json);
      expect(ActivityHistoryEntry.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityHistoryEntry.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivitySyncMutation round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"resourceId\": \"example\", \"kind\": \"upsert\", \"payloadDigest\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"expectedRevision\": 1, \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"attempts\": 0, \"state\": \"pending\"}",
              )
              as Map<String, dynamic>;
      final value = ActivitySyncMutation.fromJson(json);
      expect(ActivitySyncMutation.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivitySyncMutation.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivitySyncBatch round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"mutations\": [], \"generation\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivitySyncBatch.fromJson(json);
      expect(ActivitySyncBatch.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivitySyncBatch.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivitySyncConflict round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"resourceId\": \"example\", \"localDigest\": \"dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd\", \"remoteDigest\": \"eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee\", \"remoteRevision\": 1, \"detectedAt\": \"2026-11-18T12:00:00.000Z\", \"resolution\": \"unresolved\", \"fieldNames\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivitySyncConflict.fromJson(json);
      expect(ActivitySyncConflict.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivitySyncConflict.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivitySyncAck round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"batchId\": \"example\", \"scope\": \"test-user\", \"receivedAt\": \"2026-11-18T12:00:00.000Z\", \"acknowledgedIds\": [], \"retryIds\": [], \"conflicts\": [], \"complete\": false}",
              )
              as Map<String, dynamic>;
      final value = ActivitySyncAck.fromJson(json);
      expect(ActivitySyncAck.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivitySyncAck.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityDeviceCheckpoint round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"scope\": \"test-user\", \"savedAt\": \"2026-11-18T12:00:00.000Z\", \"revision\": 1, \"saved\": [], \"collections\": [], \"items\": [], \"schemaVersion\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityDeviceCheckpoint.fromJson(json);
      expect(ActivityDeviceCheckpoint.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityDeviceCheckpoint.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityExportPolicy round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"includeNotes\": false, \"includeCoordinates\": false, \"includeBookingReferences\": false, \"includeAttribution\": true, \"maximumItems\": 100, \"format\": \"json\", \"version\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityExportPolicy.fromJson(json);
      expect(ActivityExportPolicy.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityExportPolicy.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityExportBundle round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"format\": \"json\", \"content\": \"{}\", \"digest\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"itemCount\": 1, \"warningCodes\": [], \"schemaVersion\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityExportBundle.fromJson(json);
      expect(ActivityExportBundle.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityExportBundle.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityImportPreview round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"sourceDigest\": \"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\", \"products\": [], \"duplicateIds\": [], \"rejectedCount\": 0, \"warningCodes\": [], \"requiresConfirmation\": true}",
              )
              as Map<String, dynamic>;
      final value = ActivityImportPreview.fromJson(json);
      expect(ActivityImportPreview.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityImportPreview.tryDecode({
          ...json,
          'unexpected': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityAuditEvent round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"resourceId\": \"example\", \"kind\": \"saved\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\", \"reasonCodes\": [], \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityAuditEvent.fromJson(json);
      expect(ActivityAuditEvent.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityAuditEvent.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityDashboard round trip keeps immutable validated redacted contracts',
    () {
      final json =
          jsonDecode(
                "{\"scope\": \"test-user\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"savedCount\": 0, \"collectionCount\": 0, \"pendingBookingCount\": 0, \"confirmedBookingCount\": 0, \"unreadNotificationCount\": 0, \"syncPendingCount\": 0, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityDashboard.fromJson(json);
      expect(ActivityDashboard.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityDashboard.tryDecode({...json, 'unexpected': true}).isSuccess,
        isFalse,
      );
    },
  );
}
