import 'package:test/test.dart';
import 'package:challenge_box/db/models/challenge_day_completed.dart';

void main() {
  group('ChallengeDayCompleted', () {
    test('can map to database representation and back', () {
      final testChallengeId = 1;
      final testCompletedDate = DateTime.now();
      final challengeDayCompleted =
          ChallengeDayCompleted(testChallengeId, testCompletedDate);
      challengeDayCompleted.id = 1;

      final dbMappedChallengeDayCompleted = challengeDayCompleted.toMap();
      final fromMappedChallengeDayCompleted =
          ChallengeDayCompleted.fromMap(dbMappedChallengeDayCompleted);

      expect(
        fromMappedChallengeDayCompleted.id,
        equals(challengeDayCompleted.id),
      );
      expect(
        fromMappedChallengeDayCompleted.challengeId,
        equals(challengeDayCompleted.challengeId),
      );
      expect(
        fromMappedChallengeDayCompleted.completedDate.day,
        equals(challengeDayCompleted.completedDate.day),
      );
    });
  });
}
