import 'package:test/test.dart';
import 'legacy_helpers.dart';

void main() {
  test(
    'existing FlutterFlow age validation recognizes supplier startAge and endAge',
    () {
      final result = activityTravelerValidation(
        [
          {'ageBand': 'ADULT', 'startAge': 18, 'endAge': 120},
          {'ageBand': 'CHILD', 'startAge': 3, 'endAge': 17},
        ],
        [30, 8],
        1,
        10,
      );
      expect(result['travelerGroups'], {'adult': 1, 'child': 1});
    },
  );
  test('existing distance label rejects negative and nonfinite values', () {
    expect(attractionDistanceText(double.nan, 'en'), 'Location unavailable');
    expect(attractionDistanceText(-1, 'en'), 'Location unavailable');
  });
  test('existing rating helper rejects invalid values without throwing', () {
    expect(tripplActivitesRatingDouble(double.nan), 0);
    expect(tripplActivitesRatingDouble(double.infinity), 0);
    expect(tripplActivitesRatingDouble(6), 0);
    expect(tripplActivitesRatingDouble(4.89), 4.8);
  });
}
