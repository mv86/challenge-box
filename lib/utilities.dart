import 'package:flutter/material.dart';

DateTime toDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

int toEpochTime(DateTime datetime) {
  if (datetime == null) return null;
  return datetime.millisecondsSinceEpoch;
}

DateTime toDateTime(int epochTime) {
  if (epochTime == null) return null;
  return DateTime.fromMillisecondsSinceEpoch(epochTime);
}

Widget futureBuilderWrapper({
  @required Function child,
  @required Function futureAction,
  int id,
}) {
  return FutureBuilder(
    future: id != null ? futureAction(id) : futureAction(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return new Text(
            '${snapshot.error}',
            style: TextStyle(color: Colors.red),
          );
        } else {
          return child(snapshot.data);
        }
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}
