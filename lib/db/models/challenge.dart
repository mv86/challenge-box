import 'package:challenge_box/db/db_constants.dart';

import '../../utility_functions.dart';

class Challenge {
  int id;
  String name;
  DateTime startDate;
  int longestDurationDays = 0;
  bool failed = false;

  Challenge(this.name, this.startDate);

  Challenge.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    startDate = DateTime.fromMillisecondsSinceEpoch(map[columnStartDate]);
    longestDurationDays = map[columnLongestDuration];
    failed = (map[columnFailed] == 0) ? false : true;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnStartDate: startDate.millisecondsSinceEpoch,
      columnLongestDuration: longestDurationDays,
      columnFailed: failed ? 1 : 0,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  daysCompleted() {
    if (failed) return 0;
    return _todaysDate().difference(startDate).inDays;
  }

  datesCompleted() {
    return List.generate(
        daysCompleted(), (i) => _todaysDate().subtract(Duration(days: i + 1)));
  }

  fail() {
    if (daysCompleted() > longestDurationDays) {
      longestDurationDays = daysCompleted();
    }
    failed = true;
  }

  restart() {
    failed = false;
    startDate = _todaysDate();
  }

  stats() {
    String daysCompletedStats;
    String longestDurationDaysStats;

    if (failed) {
      daysCompletedStats = 'Marked as failed!';
    } else {
      daysCompletedStats = 'Completed: ${daysCompleted()} day';
      if (daysCompleted() != 1) daysCompletedStats += 's';
    }

    longestDurationDaysStats = 'Longest duration: $longestDurationDays day';
    if (longestDurationDays != 1) longestDurationDaysStats += 's';

    return '$daysCompletedStats\n$longestDurationDaysStats';
  }

  _todaysDate() => toDate(DateTime.now());
}
