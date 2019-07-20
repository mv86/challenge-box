import 'dart:io' show Directory;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableChallenges = 'challenges';
final String columnId = '_id';
final String columnName = 'name';
final String columnStartDate = 'start_date';
final String columnDaysCompleted = 'days_completed';
final String columnFailed = 'failed';

// data model class
class Challenge {

  int id;
  String name;
  DateTime startDate;
  int daysCompleted;
  bool failed;


  Challenge();

  // convenience constructor to create a Word object
  Challenge.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    startDate = map[columnStartDate];
    daysCompleted = map[columnDaysCompleted];
    failed = map[columnFailed];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnStartDate: startDate,
      columnDaysCompleted: daysCompleted,
      columnFailed: failed,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "ChallengeHub.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

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

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
    );
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableChallenges (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnStartDate DATETIME NOT NULL,
        $columnDaysCompleted INTEGER NOT NULL DEFAULT 0,
        $columnFailed BOOLEAN NOT NULL DEFAULT 0
      )'''
    );
  }

  // Database helper methods:

  Future<int> insert(Challenge challenge) async {
    Database db = await database;
    print('Challenge');
    print(challenge);
    // int id = await db.insert(tableChallenges, challenge.toMap());
    return 1;
    // return id;
  }

  Future<Challenge> query(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableChallenges,
        columns: [columnId, columnName, columnStartDate, columnDaysCompleted, columnFailed],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Challenge.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Challenge>> queryAllWords(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(
      tableChallenges,
      columns: [columnId, columnName, columnStartDate, columnDaysCompleted, columnFailed],
    );
    List<Challenge> challengeMaps = [];
    for (var map in maps) {
      challengeMaps.add(Challenge.fromMap(map));
    }
    return challengeMaps;
  }
  // TODO: delete(int id)
  // TODO: update(Word word)
}