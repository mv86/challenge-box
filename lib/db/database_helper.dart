import 'dart:io' show Directory;
import 'package:challenge_box/db/models/challenge_day_completed.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:challenge_box/db/db_constants.dart';
import 'package:challenge_box/db/models/challenge.dart';

import 'db_migrations.dart';

class DatabaseHelper {
  static final _databaseName = "ChallengeBox.db";
  // Database version when started using new migration system
  static final _seed = 2;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: migrationScripts.length + _seed,
      onCreate: (Database db, int version) async {
        initScript.forEach((command) async => await db.execute(command));
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var i = oldVersion - _seed; i < newVersion - _seed; i++) {
          await db.execute(migrationScripts[i]);
        }
      },
    );
  }

  Future<int> insertChallenge(Challenge challenge) async {
    Database db = await database;
    int id = await db.insert(tableChallenges, challenge.toMap());
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
