import 'package:challenge_box/db/db_constants.dart';

final List<String> initScript = [
  '''
  CREATE TABLE $tableChallenges (
    $columnId INTEGER PRIMARY KEY,
    $columnName TEXT NOT NULL,
    $columnStartDate INTEGER NOT NULL,
    $columnLongestDuration INTEGER NOT NULL DEFAULT 0,
    $columnFailed BIT NOT NULL DEFAULT 0
  );
  ''',
];

final List<String> migrationScripts = [
  '''
  CREATE TABLE $tableChallengeDaysCompleted (
    $columnId INTEGER PRIMARY KEY,
    $columnChallengeIdFk INTEGER NOT NULL,
    $columnCompletedDate INTEGER NOT NULL,
    FOREIGN KEY($columnChallengeIdFk) REFERENCES $tableChallenges($columnId)
  );
  ''',
];
