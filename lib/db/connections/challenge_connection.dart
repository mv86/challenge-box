import 'package:challenge_box/db/connections/db_connection.dart';
import 'package:challenge_box/db/constants.dart';
import 'package:challenge_box/db/models/challenge.dart';
import 'package:sqflite/sqflite.dart';

class ChallengeConnection {
  final database = DatabaseConnection.instance.database;

  ChallengeConnection();

  Future<void> insertChallenge(Challenge challenge) async {
    Database db = await database;
    await db.insert(tableChallenges, challenge.toMap());
  }

  Future<List<Challenge>> queryShortTermChallenges() async {
    final challenges = await _queryCurrentChallenges(
      whereClause: '$columnType = ${ChallengeType.shortTerm.index}',
      orderByClause: "IFNULL($columnEndDate, $dummyFutureDate)",
    );

    return [...challenges.map((challenge) => ShortTerm.fromMap(challenge))];
  }

  Future<List<Challenge>> queryCommitmentChallenges() async {
    final challenges = await _queryCurrentChallenges(
      whereClause: '$columnType = ${ChallengeType.commitment.index}',
      orderByClause:
          "IFNULL($columnStartDate, $dummyFutureDate) ASC, $columnLongestDuration DESC",
    );

    return [...challenges.map((challenge) => Commitment.fromMap(challenge))];
  }

  Future<List<Map>> _queryCurrentChallenges({
    whereClause,
    orderByClause,
  }) async {
    Database db = await database;

    return await db.query(
      tableChallenges,
      columns: [
        columnId,
        columnType,
        columnName,
        columnStartDate,
        columnLongestDuration,
        columnFailed,
        columnFailedDate,
        columnEndDate
      ],
      where: whereClause,
      orderBy: orderByClause,
    );
  }

  Future<void> updateChallenge(Challenge challenge) async {
    Database db = await database;
    await db.update(tableChallenges, challenge.toMap(),
        where: "$columnId = ?", whereArgs: [challenge.id]);
  }

  Future<void> deleteChallenge(Challenge challenge) async {
    Database db = await database;
    await db.delete(
      tableChallenges,
      where: '$columnId = ?',
      whereArgs: [challenge.id],
    );
  }
}
