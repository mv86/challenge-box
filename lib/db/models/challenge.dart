import 'package:challenge_box/db/constants.dart';

import '../../utility_functions.dart';

class Challenge {
  int id;
  String name;
  DateTime startDate;
  int longestDurationDays = 0;
  bool failed = false;
  DateTime failedDate;
  DateTime endDate;

  Challenge(this.name, this.startDate);

  Challenge.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    startDate = _toDateTime(map[columnStartDate]);
    longestDurationDays = map[columnLongestDuration];
    failed = (map[columnFailed] == 0) ? false : true;
    failedDate = _toDateTime(map[columnFailedDate]);
    endDate = _toDateTime(map[columnEndDate]);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnStartDate: _toEpochTime(startDate),
      columnLongestDuration: longestDurationDays,
      columnFailed: failed ? 1 : 0,
      columnFailedDate: _toEpochTime(failedDate),
      columnEndDate: _toEpochTime(endDate),
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  int daysCompleted() {
    if (failed) return 0;
    return _todaysDate().difference(startDate).inDays;
  }

  List<DateTime> datesCompleted() {
    return List.generate(
        daysCompleted(), (i) => _todaysDate().subtract(Duration(days: i + 1)));
  }

  bool failedToday() {
    return failedDate == _todaysDate();
  }

  void fail() {
    if (daysCompleted() > longestDurationDays) {
      longestDurationDays = daysCompleted();
    }
    failed = true;
    failedDate = _todaysDate();
  }

  void restart() {
    if (daysCompleted() > longestDurationDays) {
      longestDurationDays = daysCompleted();
    }
    failed = false;
    failedDate = null;
    startDate = _todaysDate();
  }

  String stats() {
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

  DateTime _todaysDate() => toDate(DateTime.now());

  int _toEpochTime(DateTime datetime) {
    if (datetime == null) return null;
    return datetime.millisecondsSinceEpoch;
  }

  DateTime _toDateTime(int epochTime) {
    if (epochTime == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(epochTime);
  }
}
