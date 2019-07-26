import 'package:challenge_box/db/db_constants.dart';
import 'package:recase/recase.dart';

class Challenge {
  int id;
  String name;
  DateTime startDate;
  int longestDuration = 0;
  bool failed = false;

  Challenge();

  Challenge.fromMap(Map<String, dynamic> map) {
    ReCase rc = ReCase(map[columnName]);
    id = map[columnId];
    name = rc.titleCase;
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

  stats() {
    return'Completed: ${daysCompleted()} days\nLongest duration: $longestDuration days';
  } 
}
