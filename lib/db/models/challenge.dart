import 'package:challenge_box/db/constants.dart';
import 'package:challenge_box/utilities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ChallengeType {
  commitment,
  shortTerm,
}

abstract class Challenge {
  int id;
  String name;
  DateTime startDate;
  DateTime endDate;
  DateTime failedDate;
  bool failed = false;
  int longestDurationDays = 0;

  ChallengeType type;

  Challenge({this.name, this.startDate, this.endDate, this.type});

  void restart();
  String stats();

  Challenge.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    type = ChallengeType.values[map[columnType]];
    name = map[columnName];
    startDate = toDateTime(map[columnStartDate]);
    longestDurationDays = map[columnLongestDuration];
    failed = (map[columnFailed] == 0) ? false : true;
    failedDate = toDateTime(map[columnFailedDate]);
    endDate = toDateTime(map[columnEndDate]);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnType: type.index,
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

  void fail() {
    if (daysCompleted() > longestDurationDays) {
      longestDurationDays = daysCompleted();
    }
    failed = true;
    failedDate = _todaysDate();
    startDate = null;
    endDate = null;
  }

  bool failedToday() {
    return failedDate == _todaysDate();
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

  DateTime _todaysDate() => toDate(DateTime.now());

  String _dayString(int numberOfDays) {
    final dayString = numberOfDays == 1 ? 'day' : 'days';
    return '$numberOfDays $dayString';
  }
}

class Commitment extends Challenge {
  Commitment({name, startDate, type = ChallengeType.commitment})
      : super(name: name, startDate: startDate, type: type);

  Commitment.fromMap(map) : super.fromMap(map);

  IconData icon = Icons.timer_off;

  @override
  restart() {
    if (daysCompleted() > longestDurationDays) {
      longestDurationDays = daysCompleted();
    }
    failed = false;
    failedDate = null;
    startDate = _todaysDate();
  }

  @override
  stats() {
    final daysCompletedStats = failed
        ? 'Marked as failed!'
        : 'Completed: ${_dayString(daysCompleted())}';

    return '$daysCompletedStats\nLongest duration: ${_dayString(longestDurationDays)}';
  }
}

class ShortTerm extends Challenge {
  ShortTerm({name, startDate, endDate, type = ChallengeType.shortTerm})
      : super(name: name, startDate: startDate, endDate: endDate, type: type);

  ShortTerm.fromMap(map) : super.fromMap(map);

  IconData icon = Icons.timer;

  @override
  restart() {
    // TODO Do I want to restart ShortTerm Challenge?
  }

  @override
  stats() {
    if (endDate != null) {
      final daysToGo = endDate.difference(_todaysDate()).inDays;
      final fomattedEndDate = DateFormat("dd/MM/yyyy").format(endDate);
      return 'Finishes On: $fomattedEndDate\nOnly ${_dayString(daysToGo)} to go';
    } else {
      return 'Challenge Failed!';
    }
  }
}
