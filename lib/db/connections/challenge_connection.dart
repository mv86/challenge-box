import 'package:challenge_box/db/connections/db_connection.dart';
import 'package:challenge_box/db/constants.dart';
import 'package:challenge_box/db/models/challenge.dart';
import 'package:sqflite/sqflite.dart';

class ChallengeConnection {
  final database = DatabaseConnection.instance.database;

  ChallengeConnection();

  insertChallenge(Challenge challenge) async {
    Database db = await database;
    int id;
    try {
      id = await db.insert(tableChallenges, challenge.toMap());
    } on DatabaseException catch (error) {
      if (!error.toString().contains('UNIQUE constraint failed')) {
        rethrow;
      }
    }
    return id;
  }

  Future<Challenge> queryChallenge(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(
      tableChallenges,
      columns: [
        columnId,
        columnName,
        columnStartDate,
        columnLongestDuration,
        columnFailed
      ],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return Challenge.fromMap(maps.first);
    }
    return null;
  }

  Future<List<String>> queryChallengeNames() async {
    Database db = await database;
    final maps = await db.query(
      tableChallenges,
      columns: [columnName],
    );
    return List.generate(maps.length, (i) => maps[i][columnName]);
  }

  Future<List<Challenge>> queryCurrentChallenges() async {
    Database db = await database;

    List<Map> maps = await db.query(
      tableChallenges,
      columns: [
        columnId,
        columnName,
        columnStartDate,
        columnLongestDuration,
        columnFailed
      ],
    );

    List<Challenge> challengeMaps = [];
    for (var map in maps) {
      challengeMaps.add(Challenge.fromMap(map));
    }
    return challengeMaps;
  }

  updateChallenge(Challenge challenge) async {
    Database db = await database;
    await db.update(tableChallenges, challenge.toMap(),
        where: "$columnId = ?", whereArgs: [challenge.id]);
  }

  deleteChallenge(Challenge challenge) async {
    Database db = await database;
    await db.delete(
      tableChallenges,
      where: '$columnId = ?',
      whereArgs: [challenge.id],
    );
  }
}
