import 'package:challenge_box/db/constants.dart';

final List<String> initScript = [
  '''
  CREATE TABLE $tableChallenges (
    $columnId INTEGER PRIMARY KEY,
    $columnName TEXT NOT NULL,
    $columnStartDate INTEGER NULL,
    $columnLongestDuration INTEGER NOT NULL DEFAULT 0,
    $columnFailed BIT NOT NULL DEFAULT 0,
    $columnFailedDate INTEGER NULL,
    $columnEndDate INTEGER NULL,
    CONSTRAINT $uniqueChallengeName UNIQUE ($columnName)
  );
  ''',
  '''
  CREATE TABLE $tableChallengeDaysCompleted (
    $columnId INTEGER PRIMARY KEY,
    $columnChallengeIdFk INTEGER NOT NULL,
    $columnCompletedDate INTEGER NOT NULL,
    FOREIGN KEY($columnChallengeIdFk) REFERENCES $tableChallenges($columnId)
  );
  ''',
];

final List<String> migrationScripts = [];
