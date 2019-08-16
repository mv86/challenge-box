import 'dart:io' show Directory;
import 'package:challenge_box/db/migrations.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  static final _databaseName = "ChallengeBox.db";
  static final _seed = 1;

  DatabaseConnection._privateConstructor();
  static final instance = DatabaseConnection._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      print('old db');
      final version = await _database.getVersion();
      print(version);
    }
    if (_database != null) return _database;
    _database = await _initDatabase();
    print('in if');
    final version = await _database.getVersion();
    print(version);
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
}
