import 'dart:io' show Directory;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:challenge_box/db/db_constants.dart';
import 'package:challenge_box/db/models/challenge.dart';

class DatabaseHelper {
  static final _databaseName = "ChallengeBox.db";
  static final _databaseVersion = 2;

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

    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableChallenges (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnStartDate INTEGER NOT NULL,
        $columnLongestDuration INTEGER NOT NULL DEFAULT 0,
        $columnFailed BIT NOT NULL DEFAULT 0
      );'''
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // await db.execute('TODO');
  }

  Future<int> insertChallenge(Challenge challenge) async {
    Database db = await database;
    int id = await db.insert(tableChallenges, challenge.toMap());
    return id;
  }

  Future<Challenge> queryChallenge(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableChallenges,
        columns: [columnId, columnName, columnStartDate, columnLongestDuration, columnFailed],
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
      columns: [columnId, columnName, columnStartDate, columnLongestDuration, columnFailed],
    );

    List<Challenge> challengeMaps = [];
    for (var map in maps) {
      challengeMaps.add(Challenge.fromMap(map));
    }
    return challengeMaps;
  }

  updateChallenge(Challenge challenge) async {
    Database db = await database;
    await db.update(tableChallenges, challenge.toMap(), where: "$columnId = ?", whereArgs: [challenge.id]);
  }
  
  deleteChallenge(Challenge challenge) async {
    Database db = await database;
    await db.delete(tableChallenges, where: '$columnId = ?', whereArgs: [challenge.id]);
  }
}
