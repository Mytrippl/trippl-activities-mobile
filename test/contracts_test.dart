import 'dart:convert';
import 'package:test/test.dart';
import 'package:trippl_activities_mobile/trippl_activities_mobile.dart';

void main() {
  test(
    'ActivityCoordinate preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode("{\"latitude\": 0.0, \"longitude\": 0.0}")
              as Map<String, dynamic>;
      final value = ActivityCoordinate.fromJson(json);
      expect(ActivityCoordinate.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityCoordinate.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityAddress preserves canonical data and rejects unknown fields',
    () {
      final json = jsonDecode("{}") as Map<String, dynamic>;
      final value = ActivityAddress.fromJson(json);
      expect(ActivityAddress.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityAddress.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityAttribution preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"displayName\": \"example\", \"kind\": \"provider\", \"required\": true}",
              )
              as Map<String, dynamic>;
      final value = ActivityAttribution.fromJson(json);
      expect(ActivityAttribution.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityAttribution.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test('ActivityPhoto preserves canonical data and rejects unknown fields', () {
    final json =
        jsonDecode(
              "{\"id\": \"example\", \"url\": \"https://example.com/photo.jpg\", \"attributions\": []}",
            )
            as Map<String, dynamic>;
    final value = ActivityPhoto.fromJson(json);
    expect(ActivityPhoto.fromJson(value.toJson()), value);
    expect(value.copyWith(), value);
    expect(value.toString(), contains('redacted'));
    expect(
      ActivityPhoto.tryDecode({...json, 'extra': true}).isSuccess,
      isFalse,
    );
  });
  test('ActivityReview preserves canonical data and rejects unknown fields', () {
    final json =
        jsonDecode(
              "{\"id\": \"example\", \"authorName\": \"example\", \"verified\": false, \"attributions\": []}",
            )
            as Map<String, dynamic>;
    final value = ActivityReview.fromJson(json);
    expect(ActivityReview.fromJson(value.toJson()), value);
    expect(value.copyWith(), value);
    expect(value.toString(), contains('redacted'));
    expect(
      ActivityReview.tryDecode({...json, 'extra': true}).isSuccess,
      isFalse,
    );
  });
  test(
    'ActivityRating preserves canonical data and rejects unknown fields',
    () {
      final json = jsonDecode("{\"maximum\": 5}") as Map<String, dynamic>;
      final value = ActivityRating.fromJson(json);
      expect(ActivityRating.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityRating.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityDuration preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode("{\"approximate\": true, \"flexible\": false}")
              as Map<String, dynamic>;
      final value = ActivityDuration.fromJson(json);
      expect(ActivityDuration.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityDuration.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityGuideLanguage preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"code\": \"en\", \"kind\": \"guide\", \"available\": true, \"requiresSelection\": false}",
              )
              as Map<String, dynamic>;
      final value = ActivityGuideLanguage.fromJson(json);
      expect(ActivityGuideLanguage.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityGuideLanguage.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test('ActivityAgeBand preserves canonical data and rejects unknown fields', () {
    final json =
        jsonDecode(
              "{\"id\": \"example\", \"category\": \"adult\", \"startAge\": 0, \"endAge\": 120, \"minimumTravelers\": 0, \"countsTowardCapacity\": true, \"requiresAdult\": false}",
            )
            as Map<String, dynamic>;
    final value = ActivityAgeBand.fromJson(json);
    expect(ActivityAgeBand.fromJson(value.toJson()), value);
    expect(value.copyWith(), value);
    expect(value.toString(), contains('redacted'));
    expect(
      ActivityAgeBand.tryDecode({...json, 'extra': true}).isSuccess,
      isFalse,
    );
  });
  test(
    'ActivityTraveler preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"age\": 30, \"requiresAssistance\": false}",
              )
              as Map<String, dynamic>;
      final value = ActivityTraveler.fromJson(json);
      expect(ActivityTraveler.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityTraveler.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityTravelerMix preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"travelers\": [], \"minimumTravelers\": 1, \"maximumTravelers\": 100, \"pricingBasis\": \"perPerson\", \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityTravelerMix.fromJson(json);
      expect(ActivityTravelerMix.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityTravelerMix.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityEligibility preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"eligible\": false, \"totalTravelers\": 1, \"unsupportedTravelerIds\": [], \"reasonCodes\": [], \"assignedCategories\": [], \"capacityTravelers\": 0, \"requiresReview\": false}",
              )
              as Map<String, dynamic>;
      final value = ActivityEligibility.fromJson(json);
      expect(ActivityEligibility.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityEligibility.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test('ActivityMoney preserves canonical data and rejects unknown fields', () {
    final json =
        jsonDecode(
              "{\"currency\": \"USD\", \"amountMinor\": 1, \"decimals\": 2}",
            )
            as Map<String, dynamic>;
    final value = ActivityMoney.fromJson(json);
    expect(ActivityMoney.fromJson(value.toJson()), value);
    expect(value.copyWith(), value);
    expect(value.toString(), contains('redacted'));
    expect(
      ActivityMoney.tryDecode({...json, 'extra': true}).isSuccess,
      isFalse,
    );
  });
  test(
    'ActivityPriceComponent preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"label\": \"example\", \"unit\": {\"currency\": \"USD\", \"amountMinor\": 1, \"decimals\": 2}, \"quantity\": 1, \"kind\": \"base\", \"included\": true}",
              )
              as Map<String, dynamic>;
      final value = ActivityPriceComponent.fromJson(json);
      expect(ActivityPriceComponent.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityPriceComponent.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityPriceRule preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"money\": {\"currency\": \"USD\", \"amountMinor\": 1, \"decimals\": 2}, \"basis\": \"perPerson\", \"minimumTravelers\": 1, \"maximumTravelers\": 100, \"minimumUnits\": 1, \"priority\": 0}",
              )
              as Map<String, dynamic>;
      final value = ActivityPriceRule.fromJson(json);
      expect(ActivityPriceRule.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityPriceRule.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityPriceQuote preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"productId\": \"product\", \"optionId\": \"option\", \"requestFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T14:00:00.000Z\", \"total\": {\"currency\": \"USD\", \"amountMinor\": 1, \"decimals\": 2}, \"components\": [], \"indicative\": true, \"revision\": 1, \"slotId\": \"slot\"}",
              )
              as Map<String, dynamic>;
      final value = ActivityPriceQuote.fromJson(json);
      expect(ActivityPriceQuote.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityPriceQuote.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityPriceBreakdown preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"total\": {\"currency\": \"USD\", \"amountMinor\": 1, \"decimals\": 2}, \"components\": [], \"travelerCount\": 1, \"basis\": \"unknown\", \"complete\": false, \"warningCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivityPriceBreakdown.fromJson(json);
      expect(ActivityPriceBreakdown.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityPriceBreakdown.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityCancellationTier preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"cutoffAt\": \"2026-11-18T12:00:00.000Z\", \"refundBasisPoints\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityCancellationTier.fromJson(json);
      expect(ActivityCancellationTier.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityCancellationTier.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityCancellationPolicy preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"kind\": \"unknown\", \"tiers\": [], \"requiresReview\": true}",
              )
              as Map<String, dynamic>;
      final value = ActivityCancellationPolicy.fromJson(json);
      expect(ActivityCancellationPolicy.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityCancellationPolicy.tryDecode({
          ...json,
          'extra': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityCancellationAssessment preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"policyId\": \"example\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"unknown\", \"requiresReview\": true, \"warningCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivityCancellationAssessment.fromJson(json);
      expect(ActivityCancellationAssessment.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityCancellationAssessment.tryDecode({
          ...json,
          'extra': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityMeetingPoint preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"name\": \"example\", \"arrivalMinutesBefore\": 0, \"confirmed\": false}",
              )
              as Map<String, dynamic>;
      final value = ActivityMeetingPoint.fromJson(json);
      expect(ActivityMeetingPoint.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityMeetingPoint.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test('ActivityPickup preserves canonical data and rejects unknown fields', () {
    final json =
        jsonDecode(
              "{\"id\": \"example\", \"available\": false, \"included\": false, \"requiresSelection\": false, \"pointIds\": []}",
            )
            as Map<String, dynamic>;
    final value = ActivityPickup.fromJson(json);
    expect(ActivityPickup.fromJson(value.toJson()), value);
    expect(value.copyWith(), value);
    expect(value.toString(), contains('redacted'));
    expect(
      ActivityPickup.tryDecode({...json, 'extra': true}).isSuccess,
      isFalse,
    );
  });
  test(
    'ActivityAccessibility preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode("{\"restrictions\": [], \"confirmed\": false}")
              as Map<String, dynamic>;
      final value = ActivityAccessibility.fromJson(json);
      expect(ActivityAccessibility.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityAccessibility.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityInclusion preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"description\": \"example\", \"included\": true, \"category\": \"other\"}",
              )
              as Map<String, dynamic>;
      final value = ActivityInclusion.fromJson(json);
      expect(ActivityInclusion.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityInclusion.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test('ActivityOption preserves canonical data and rejects unknown fields', () {
    final json =
        jsonDecode(
              "{\"id\": \"example\", \"productId\": \"product\", \"title\": \"Activity\", \"priceRules\": [], \"languages\": [], \"ageBands\": [], \"minimumTravelers\": 1, \"maximumTravelers\": 100, \"active\": true}",
            )
            as Map<String, dynamic>;
    final value = ActivityOption.fromJson(json);
    expect(ActivityOption.fromJson(value.toJson()), value);
    expect(value.copyWith(), value);
    expect(value.toString(), contains('redacted'));
    expect(
      ActivityOption.tryDecode({...json, 'extra': true}).isSuccess,
      isFalse,
    );
  });
  test('ActivityProduct preserves canonical data and rejects unknown fields', () {
    final json =
        jsonDecode(
              "{\"id\": \"example\", \"title\": \"Activity\", \"options\": [], \"photos\": [], \"reviews\": [], \"categories\": [], \"inclusions\": [], \"attributions\": [], \"instantConfirmation\": false, \"revision\": 1}",
            )
            as Map<String, dynamic>;
    final value = ActivityProduct.fromJson(json);
    expect(ActivityProduct.fromJson(value.toJson()), value);
    expect(value.copyWith(), value);
    expect(value.toString(), contains('redacted'));
    expect(
      ActivityProduct.tryDecode({...json, 'extra': true}).isSuccess,
      isFalse,
    );
  });
  test('ActivitySlot preserves canonical data and rejects unknown fields', () {
    final json =
        jsonDecode(
              "{\"id\": \"example\", \"productId\": \"product\", \"optionId\": \"option\", \"startsAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"unknown\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T14:00:00.000Z\", \"languageCodes\": [], \"revision\": 1}",
            )
            as Map<String, dynamic>;
    final value = ActivitySlot.fromJson(json);
    expect(ActivitySlot.fromJson(value.toJson()), value);
    expect(value.copyWith(), value);
    expect(value.toString(), contains('redacted'));
    expect(ActivitySlot.tryDecode({...json, 'extra': true}).isSuccess, isFalse);
  });
  test(
    'ActivityAvailability preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"productId\": \"product\", \"optionId\": \"option\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"slots\": [], \"bookable\": false, \"state\": \"unknown\", \"travelerCount\": 1, \"warningCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivityAvailability.fromJson(json);
      expect(ActivityAvailability.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityAvailability.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityAvailabilityRequest preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"productId\": \"product\", \"optionId\": \"option\", \"travelDate\": \"2026-11-18\", \"travelers\": {\"travelers\": [{\"id\": \"traveler\", \"age\": 30}]}, \"currency\": \"USD\", \"language\": \"en\", \"revision\": 1, \"units\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityAvailabilityRequest.fromJson(json);
      expect(ActivityAvailabilityRequest.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityAvailabilityRequest.tryDecode({
          ...json,
          'extra': true,
        }).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivitySearchQuery preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"text\": \"all\", \"currency\": \"USD\", \"language\": \"en\", \"offset\": 0, \"limit\": 20}",
              )
              as Map<String, dynamic>;
      final value = ActivitySearchQuery.fromJson(json);
      expect(ActivitySearchQuery.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivitySearchQuery.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivitySearchFilter preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"categories\": [], \"freeCancellationOnly\": false, \"instantConfirmationOnly\": false, \"includeStale\": false}",
              )
              as Map<String, dynamic>;
      final value = ActivitySearchFilter.fromJson(json);
      expect(ActivitySearchFilter.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivitySearchFilter.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivitySearchSort preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"field\": \"recommended\", \"descending\": false, \"unknownLast\": true, \"tieBreak\": \"id\"}",
              )
              as Map<String, dynamic>;
      final value = ActivitySearchSort.fromJson(json);
      expect(ActivitySearchSort.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivitySearchSort.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityProviderRequest preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"scope\": \"test-user\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"mode\": \"search\", \"limit\": 20, \"fieldMask\": [], \"query\": {}}",
              )
              as Map<String, dynamic>;
      final value = ActivityProviderRequest.fromJson(json);
      expect(ActivityProviderRequest.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityProviderRequest.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityProviderPage preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"id\": \"example\", \"requestFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T14:00:00.000Z\", \"products\": [], \"slots\": [], \"quotes\": [], \"attributions\": [], \"complete\": false, \"warningCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivityProviderPage.fromJson(json);
      expect(ActivityProviderPage.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityProviderPage.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityProviderFailure preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"code\": \"example\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\", \"retryable\": false, \"requiresReview\": false, \"operation\": \"read\"}",
              )
              as Map<String, dynamic>;
      final value = ActivityProviderFailure.fromJson(json);
      expect(ActivityProviderFailure.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityProviderFailure.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityDiscoveryState preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"requestId\": \"example\", \"scopeFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"loading\", \"generation\": 1, \"attempt\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityDiscoveryState.fromJson(json);
      expect(ActivityDiscoveryState.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityDiscoveryState.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityResultCard preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"productId\": \"product\", \"title\": \"Activity\", \"priceLabel\": \"example\", \"ratingLabel\": \"example\", \"durationLabel\": \"example\", \"cancellationLabel\": \"example\", \"availabilityState\": \"unknown\", \"stale\": false, \"warningCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivityResultCard.fromJson(json);
      expect(ActivityResultCard.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityResultCard.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityComparison preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"productIds\": [], \"cards\": [], \"comparablePrices\": false, \"warningCodes\": [], \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityComparison.fromJson(json);
      expect(ActivityComparison.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityComparison.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivitySelection preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"productId\": \"product\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivitySelection.fromJson(json);
      expect(ActivitySelection.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivitySelection.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityCacheEntry preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"scopeFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"requestFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"savedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T14:00:00.000Z\", \"page\": {\"id\": \"example\", \"requestFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T14:00:00.000Z\", \"products\": [], \"slots\": [], \"quotes\": [], \"attributions\": [], \"complete\": false, \"warningCodes\": []}, \"offline\": false, \"schemaVersion\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityCacheEntry.fromJson(json);
      expect(ActivityCacheEntry.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityCacheEntry.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityFieldMask preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"includePhotos\": true, \"includeReviews\": false, \"includeOptions\": true, \"includeCancellation\": true, \"maximumPhotos\": 5, \"maximumReviews\": 5, \"fields\": [], \"version\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityFieldMask.fromJson(json);
      expect(ActivityFieldMask.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityFieldMask.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivitySearchResult preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"resultFingerprint\": \"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\", \"matchedCount\": 1, \"products\": [], \"offset\": 0, \"limit\": 20, \"hasMore\": false, \"incomplete\": true, \"warningCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivitySearchResult.fromJson(json);
      expect(ActivitySearchResult.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivitySearchResult.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityDeparture preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"productId\": \"product\", \"optionId\": \"option\", \"slotId\": \"slot\", \"startsAt\": \"2026-11-18T12:00:00.000Z\", \"requiresConfirmation\": true, \"warningCodes\": []}",
              )
              as Map<String, dynamic>;
      final value = ActivityDeparture.fromJson(json);
      expect(ActivityDeparture.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityDeparture.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
  test(
    'ActivityQuoteRequest preserves canonical data and rejects unknown fields',
    () {
      final json =
          jsonDecode(
                "{\"productId\": \"product\", \"optionId\": \"option\", \"slotId\": \"slot\", \"travelers\": {\"travelers\": [], \"minimumTravelers\": 1, \"maximumTravelers\": 100, \"pricingBasis\": \"perPerson\", \"revision\": 1}, \"currency\": \"USD\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"units\": 1, \"revision\": 1}",
              )
              as Map<String, dynamic>;
      final value = ActivityQuoteRequest.fromJson(json);
      expect(ActivityQuoteRequest.fromJson(value.toJson()), value);
      expect(value.copyWith(), value);
      expect(value.toString(), contains('redacted'));
      expect(
        ActivityQuoteRequest.tryDecode({...json, 'extra': true}).isSuccess,
        isFalse,
      );
    },
  );
}
