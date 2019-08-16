import 'package:challenge_box/db/connections/db_connection.dart';
import 'package:challenge_box/db/constants.dart';
import 'package:challenge_box/db/models/challenge_day_completed.dart';
import 'package:sqflite/sqflite.dart';

class ChallengeDayCompletedConnection {
  final database = DatabaseConnection.instance.database;

  ChallengeDayCompletedConnection();

  insertChallengeDaysCompleted(
    List<ChallengeDayCompleted> completedDays,
  ) async {
    Database db = await database;
    for (final completedDay in completedDays) {
      await db.insert(tableChallengeDaysCompleted, completedDay.toMap());
    }
  }

  deleteChallengeDaysCompleted(int challengeId) async {
    Database db = await database;
    await db.delete(
      tableChallengeDaysCompleted,
      where: '$columnChallengeIdFk = ?',
      whereArgs: [challengeId],
    );
  }

  Future<List<DateTime>> queryPreviousChallengeDatesCompleted(
    int challengeId,
  ) async {
    Database db = await database;
    final List<DateTime> previousDatesCompleted = [];

    List<Map> maps = await db.query(
      tableChallengeDaysCompleted,
      columns: [columnChallengeIdFk, columnCompletedDate],
      where: '$columnChallengeIdFk = ?',
      whereArgs: [challengeId],
    );

    for (final map in maps) {
      final challengeDayCompleted = ChallengeDayCompleted.fromMap(map);
      previousDatesCompleted.add(challengeDayCompleted.completedDate);
    }

    return previousDatesCompleted;
  }
}
