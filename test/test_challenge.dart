import 'package:test/test.dart';
import 'package:challenge_box/db/models/challenge.dart';

void main() {
  group('Challenge', () {
    String challengeName;
    DateTime now;
    DateTime startDateToday;
    DateTime startDateYesterday;

    setUp(() {
      challengeName = 'test name';
      now = DateTime.now();
      startDateToday = DateTime(now.year, now.month, now.day);
      startDateYesterday = startDateToday.subtract(Duration(days: 1));
    });

    test('can be instantiated with challengeName and start date', () {
      final challenge = Challenge(challengeName, startDateToday);
      final expectedStats = 'Completed: 0 days\nLongest duration: 0 days';

      expect(challenge.name, equals(challengeName));
      expect(challenge.startDate, equals(startDateToday));
      expect(challenge.daysCompleted(), equals(0));
      expect(challenge.longestDurationDays, equals(0));
      expect(challenge.stats(), equals(expectedStats));
    });

    test('daysCompleted and stats update on date change', () {
      final challenge = Challenge(challengeName, startDateYesterday);
      final expectedStats = 'Completed: 1 day\nLongest duration: 0 days';

      expect(challenge.daysCompleted(), equals(1));
      expect(challenge.stats(), equals(expectedStats));
    });

    test('can fail a challenge and update longestDurationDays and stats', () {
      final challenge = Challenge(challengeName, startDateYesterday);
      final expectedStats = 'Marked as failed!\nLongest duration: 1 day';

      challenge.fail();

      expect(challenge.failed, equals(true));
      expect(challenge.daysCompleted(), equals(0));
      expect(challenge.longestDurationDays, equals(1));
      expect(challenge.stats(), equals(expectedStats));
    });

    test('longestDurationDays not updated on fail when daysCompleted less', () {
      final challenge = Challenge(challengeName, startDateYesterday);
      final expectedStats = 'Marked as failed!\nLongest duration: 2 days';

      challenge.longestDurationDays = 2;
      challenge.fail();

      expect(challenge.longestDurationDays, equals(2));
      expect(challenge.stats(), equals(expectedStats));
    });

    test('daysCompleted remains at 0 for a failed challenge', () {
      final challenge = Challenge(challengeName, startDateYesterday);
      expect(challenge.daysCompleted(), equals(1));

      challenge.fail();

      expect(challenge.daysCompleted(), equals(0));
    });

    test('restart resets failed status and startDate', () {
      final challenge = Challenge(challengeName, startDateYesterday);

      challenge.fail();
      expect(challenge.failed, equals(true));

      challenge.restart();

      expect(challenge.failed, equals(false));
      expect(challenge.startDate.day, equals(DateTime.now().day));
    });

    test('can map to database representation and back', () {
      final challenge = Challenge(challengeName, startDateToday);
      challenge.id = 1;

      final dbMappedChallenge = challenge.toMap();
      final fromMappedChallenge = Challenge.fromMap(dbMappedChallenge);

      expect(fromMappedChallenge.id, equals(challenge.id));
      expect(fromMappedChallenge.name, equals(challenge.name));
      expect(
          fromMappedChallenge.startDate.day, equals(challenge.startDate.day));
      expect(fromMappedChallenge.longestDurationDays,
          equals(challenge.longestDurationDays));
      expect(fromMappedChallenge.failed, equals(challenge.failed));
    });

    test('can see a list of challenge dates completed', () {
      final startDateThreeDaysAgo = startDateToday.subtract(Duration(days: 3));
      final challenge = Challenge(challengeName, startDateThreeDaysAgo);

      final expectedDates = [
        startDateToday.subtract(Duration(days: 1)),
        startDateToday.subtract(Duration(days: 2)),
        startDateToday.subtract(Duration(days: 3)),
      ];

      expect(challenge.datesCompleted(), equals(expectedDates));
    });
  });
}
