import 'package:flutter/material.dart';

DateTime toDate(DateTime dateTime) {
  if (dateTime == null) return null;
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

int toEpochTime(DateTime dateTime) {
  if (dateTime == null) return null;
  return dateTime.millisecondsSinceEpoch;
}

DateTime toDateTime(int epochTime) {
  if (epochTime == null) return null;
  return DateTime.fromMillisecondsSinceEpoch(epochTime);
}

String escapeApostrophes(String string) {
  return string.replaceAll(new RegExp("'"), "''");
}

String unescapeApostrophes(String string) {
  return string.replaceAll(new RegExp("''"), "'");
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
