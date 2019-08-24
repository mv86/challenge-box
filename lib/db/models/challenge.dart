import 'package:challenge_box/db/constants.dart';
import 'package:challenge_box/utilities.dart';
import 'package:intl/intl.dart';

class Challenge {
  int id;
  String name;
  DateTime startDate;
  int longestDurationDays = 0;
  bool failed = false;
  DateTime failedDate;
  DateTime endDate;

  Challenge(this.name, this.startDate, this.endDate);

  Challenge.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    startDate = toDateTime(map[columnStartDate]);
    longestDurationDays = map[columnLongestDuration];
    failed = (map[columnFailed] == 0) ? false : true;
    failedDate = toDateTime(map[columnFailedDate]);
    endDate = toDateTime(map[columnEndDate]);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnStartDate: toEpochTime(startDate),
      columnLongestDuration: longestDurationDays,
      columnFailed: failed ? 1 : 0,
      columnFailedDate: toEpochTime(failedDate),
      columnEndDate: toEpochTime(endDate),
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
      daysCompleted(),
      (i) => _todaysDate().subtract(Duration(days: i + 1)),
    );
  }

  bool failedToday() {
    return failedDate == _todaysDate();
  }

  bool isTimed() {
    return endDate != null;
  }

  void fail() {
    if (daysCompleted() > longestDurationDays) {
      longestDurationDays = daysCompleted();
    }
    failed = true;
    failedDate = _todaysDate();
    startDate = null;
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
    return isTimed() ? timedChallengeStats() : continuousChallengeStats();
  }

  String timedChallengeStats() {
    final daysToGo = endDate.difference(_todaysDate()).inDays;
    final fomattedEndDate = DateFormat("dd/MM/yyyy").format(endDate);
    final day = daysToGo == 1 ? 'day' : 'days';
    return 'Finishes On: $fomattedEndDate\nOnly $daysToGo $day to go';
  }

  String continuousChallengeStats() {
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
}
