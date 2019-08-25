import 'package:challenge_box/utilities.dart';
import 'package:test/test.dart';
import 'package:challenge_box/db/models/challenge.dart';
import 'package:intl/intl.dart';

void main() {
  group('Commitment Challenge', () {
    // Includes test on abstract class Challenge methods
    String challengeName;
    DateTime today;
    DateTime yesterday;

    setUp(() {
      challengeName = 'test name';
      today = toDate(DateTime.now());
      yesterday = today.subtract(Duration(days: 1));
    });

    test('can be instantiated', () {
      final challenge = Commitment(
        name: challengeName,
        startDate: today,
      );
      final expectedStats = 'Completed: 0 days\nLongest duration: 0 days';

      expect(challenge.type, equals(ChallengeType.commitment));
      expect(challenge.name, equals(challengeName));
      expect(challenge.startDate, equals(today));
      expect(challenge.daysCompleted(), equals(0));
      expect(challenge.datesCompleted(), equals([]));
      expect(challenge.longestDurationDays, equals(0));
      expect(challenge.stats(), equals(expectedStats));
      expect(challenge.failedDate, equals(null));
      expect(challenge.failedToday(), equals(false));
    });

    test('fields update on date change', () {
      final challenge = Commitment(
        name: challengeName,
        startDate: yesterday,
      );
      final expectedStats = 'Completed: 1 day\nLongest duration: 0 days';

      expect(challenge.daysCompleted(), equals(1));
      expect(challenge.datesCompleted(), equals([yesterday]));
      expect(challenge.stats(), equals(expectedStats));
    });

    test('fields update on fail', () {
      final challenge = Commitment(
        name: challengeName,
        startDate: yesterday,
      );
      final expectedStats = 'Marked as failed!\nLongest duration: 1 day';

      challenge.fail();

      expect(challenge.failed, equals(true));
      expect(challenge.failedDate, equals(toDate(DateTime.now())));
      expect(challenge.startDate, equals(null));
      expect(challenge.daysCompleted(), equals(0));
      expect(challenge.datesCompleted(), equals([]));
      expect(challenge.longestDurationDays, equals(1));
      expect(challenge.stats(), equals(expectedStats));
      expect(challenge.failedToday(), equals(true));
    });

    test('fields update on restart', () {
      final challenge = Commitment(
        name: challengeName,
        startDate: yesterday,
      );
      final expectedStats = 'Completed: 0 days\nLongest duration: 1 day';

      challenge.fail();
      challenge.restart();

      expect(challenge.failed, equals(false));
      expect(challenge.failedDate, equals(null));
      expect(challenge.daysCompleted(), equals(0));
      expect(challenge.datesCompleted(), equals([]));
      expect(challenge.longestDurationDays, equals(1));
      expect(challenge.stats(), equals(expectedStats));
      expect(challenge.startDate.day, equals(DateTime.now().day));
    });

    test('longestDurationDays not updated on fail when daysCompleted less', () {
      final challenge = Commitment(
        name: challengeName,
        startDate: yesterday,
      );
      final expectedStats = 'Marked as failed!\nLongest duration: 2 days';

      challenge.longestDurationDays = 2;
      challenge.fail();

      expect(challenge.longestDurationDays, equals(2));
      expect(challenge.stats(), equals(expectedStats));
    });

    test('daysCompleted remains at 0 for a failed challenge', () {
      final challenge = Commitment(
        name: challengeName,
        startDate: yesterday,
      );
      expect(challenge.daysCompleted(), equals(1));

      challenge.fail();

      expect(challenge.daysCompleted(), equals(0));
    });

    test('can map to database representation and back', () {
      final challenge = Commitment(
        name: challengeName,
        startDate: today,
      );
      challenge.id = 1;

      final dbMappedChallenge = challenge.toMap();
      final fromMappedChallenge = Commitment.fromMap(dbMappedChallenge);

      expect(fromMappedChallenge.id, equals(challenge.id));
      expect(fromMappedChallenge.type, equals(challenge.type));
      expect(fromMappedChallenge.name, equals(challenge.name));
      expect(
        fromMappedChallenge.startDate.day,
        equals(challenge.startDate.day),
      );
      expect(
        fromMappedChallenge.longestDurationDays,
        equals(challenge.longestDurationDays),
      );
      expect(
        fromMappedChallenge.failed,
        equals(challenge.failed),
      );
      expect(
        fromMappedChallenge.failedDate,
        equals(challenge.failedDate),
      );
      expect(fromMappedChallenge.endDate, equals(null));
    });

    test('can see a list of challenge dates completed', () {
      final startDateThreeDaysAgo = today.subtract(Duration(days: 3));
      final challenge = Commitment(
        name: challengeName,
        startDate: startDateThreeDaysAgo,
      );
      final expectedDates = [
        today.subtract(Duration(days: 1)),
        today.subtract(Duration(days: 2)),
        today.subtract(Duration(days: 3)),
      ];

      expect(challenge.datesCompleted(), equals(expectedDates));
    });
  });

  group('Short-Term Challenge', () {
    String challengeName;
    DateTime twoDaysAgo;
    DateTime tomorrow;
    Challenge challenge;

    setUp(() {
      challengeName = 'test name';
      twoDaysAgo = toDate(DateTime.now().subtract(Duration(days: 2)));
      tomorrow = DateTime.now().add(Duration(days: 1));
      challenge = ShortTerm(
        name: challengeName,
        startDate: twoDaysAgo,
        endDate: tomorrow,
      );
      challenge.id = 1;
    });
    test('can be instantiated', () {
      final expectedEndDate = DateFormat("dd/MM/yyyy").format(tomorrow);
      final expectedStats = 'Finishes On: $expectedEndDate\nOnly 1 day to go';

      expect(challenge.type, equals(ChallengeType.shortTerm));
      expect(challenge.name, equals(challengeName));
      expect(challenge.startDate, equals(twoDaysAgo));
      expect(challenge.stats(), equals(expectedStats));
      expect(challenge.endDate, equals(tomorrow));
    });

    test('fields update on fail', () {
      final expectedStats = 'Challenge Failed!';

      challenge.fail();

      expect(challenge.failed, equals(true));
      expect(challenge.failedDate, equals(toDate(DateTime.now())));
      expect(challenge.startDate, equals(null));
      expect(challenge.endDate, equals(null));
      expect(challenge.daysCompleted(), equals(0));
      expect(challenge.datesCompleted(), equals([]));
      expect(challenge.longestDurationDays, equals(2));
      expect(challenge.stats(), equals(expectedStats));
      expect(challenge.failedToday(), equals(true));
    });
  });
}
