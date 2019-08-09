import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import 'db/database_helper.dart';
import 'db/models/challenge.dart';

class ChallengePage extends StatefulWidget {
  final Challenge challenge;

  ChallengePage({
    Key key,
    @required this.challenge,
  }) : super(key: key);

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challenge.name),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: CalendarCarousel(
                thisMonthDayBorderColor: Colors.grey,
                height: 420.0,
                weekdayTextStyle: TextStyle(color: Colors.blueGrey[200]),
                weekendTextStyle: TextStyle(color: Colors.black),
                selectedDateTime: DateTime.now(),
                selectedDayButtonColor: Colors.grey[600],
                selectedDayBorderColor: Colors.grey[700],
                daysHaveCircularBorder: false,
                markedDatesMap: _markedCompletedDays(widget.challenge),
                markedDateShowIcon: true,
                markedDateIconMaxShown: 1,
                markedDateIconBuilder: (event) => event.icon,
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  key: Key('deleteButton'),
                  onPressed: () =>
                      _confirm(_deletAction, widget.challenge, context),
                  child: Text('Delete'),
                ),
                RaisedButton(
                  key: Key('restartButton'),
                  onPressed: () =>
                      _confirm(_restartAction, widget.challenge, context),
                  child: Text('Restart'),
                ),
                RaisedButton(
                  key: Key('failButton'),
                  onPressed: widget.challenge.failed
                      ? null
                      : () => _confirm(_failAction, widget.challenge, context),

                  child: Text('Fail'),
                  // disabledColor: Colors.black,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Widget _dayCompleted(String day) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(
          Radius.circular(1000),
        ),
      ),
      child: Center(
        child: Text(day, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  _markedCompletedDays(Challenge challenge) {
    final eventList = EventList<Event>(events: {});

    for (var dateCompleted in challenge.datesCompleted()) {
      eventList.add(
        dateCompleted,
        Event(
          date: dateCompleted,
          title: 'Completed',
          icon: _dayCompleted(dateCompleted.day.toString()),
        ),
      );
    }

    return eventList;
  }

  final Map<String, dynamic> _deletAction = {
    'type': 'Delete',
    'do': DatabaseHelper.instance.deleteChallenge,
  };

  final Map<String, dynamic> _restartAction = {
    'type': 'Restart',
    'do': (challenge) {
      challenge.restart();
      DatabaseHelper.instance.updateChallenge(challenge);
    },
  };

  final Map<String, dynamic> _failAction = {
    'type': 'Fail',
    'do': (challenge) {
      challenge.fail();
      DatabaseHelper.instance.updateChallenge(challenge);
    },
  };

  _confirm(action, challenge, context) async {
    final confirmedAction = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('${action['type']} ${challenge.name}'),
            content: new Text('Are you sure?'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  }),
              FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
            ],
          );
        });

    if (confirmedAction) {
      action['do'](challenge);
      Navigator.of(context).pop();
    }
  }
}
