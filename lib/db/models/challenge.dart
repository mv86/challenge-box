import 'package:challenge_box/db/db_constants.dart';
import 'package:challenge_box/db/database_helper.dart';

class Challenge {
  int id;
  String name;
  DateTime startDate;
  int longestDuration = 0;
  bool failed = false;

  Challenge(this.name, this.startDate);

  Challenge.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    startDate = DateTime.fromMillisecondsSinceEpoch(map[columnStartDate]);
    longestDuration = map[columnLongestDuration];
    failed = (map[columnFailed] == 0) ? false : true;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnStartDate: startDate.millisecondsSinceEpoch,
      columnLongestDuration: longestDuration,
      columnFailed: failed ? 1 : 0,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  daysCompleted() {
    return DateTime.now().difference(startDate).inDays;
  }

  save() {
   DatabaseHelper.instance.insert(this);
  }

  fail() {
    failed = true;
    if (daysCompleted() > longestDuration) {
      longestDuration = daysCompleted();
    }
    startDate = DateTime.now();

    DatabaseHelper.instance.updateChallenge(this);
  }

  restart() {
    failed = false;
    startDate = DateTime.now();

    DatabaseHelper.instance.updateChallenge(this);
  }

  delete() {
    DatabaseHelper.instance.deleteChallenge(this);
  }

  stats() {
    return'Completed: ${daysCompleted()} days\nLongest duration: $longestDuration days';
  } 
}
