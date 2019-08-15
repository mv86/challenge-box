import 'package:challenge_box/db/database_helper.dart';
import 'package:challenge_box/db/models/challenge.dart';
import 'package:challenge_box/db/models/challenge_day_completed.dart';
import 'package:challenge_box/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

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
        body: futureBuilderWrapper(
          child: _displayChallengeData,
          futureAction:
              DatabaseHelper.instance.queryPreviousChallengeDatesCompleted,
          id: widget.challenge.id,
        ));
  }

  _displayChallengeData(previousDatesCompleted) {
    return Container(
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
              markedDatesMap: _markedCompletedDays(
                  widget.challenge, previousDatesCompleted),
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
              ),
            ],
          )
        ],
      ),
    );
  }

  _markedCompletedDays(
    Challenge challenge,
    List<DateTime> previousDatesCompleted,
  ) {
    final eventList = EventList<Event>(events: {});

    for (final currentDateCompleted in challenge.datesCompleted()) {
      eventList.add(
        currentDateCompleted,
        Event(
          date: currentDateCompleted,
          title: 'Completed',
          icon: _dayCompletedIcon(
            text: currentDateCompleted.day.toString(),
            iconColor: Colors.green,
          ),
        ),
      );
    }

    for (final DateTime previousDateCompleted in previousDatesCompleted) {
      eventList.add(
        previousDateCompleted,
        Event(
          date: previousDateCompleted,
          title: 'Previously Completed',
          icon: _dayCompletedIcon(
            text: previousDateCompleted.day.toString(),
            iconColor: Colors.green[200],
          ),
        ),
      );
    }

    return eventList;
  }

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
                  key: Key('yesButton'),
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  }),
              FlatButton(
                  key: Key('noButton'),
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

Widget _dayCompletedIcon({String text, Color iconColor}) {
  return Container(
    decoration: BoxDecoration(
      color: iconColor,
      borderRadius: BorderRadius.all(
        Radius.circular(1000),
      ),
    ),
    child: Center(
      child: Text(text, style: TextStyle(color: Colors.black)),
    ),
  );
}

final Map<String, dynamic> _deletAction = {
  'type': 'Delete',
  'do': DatabaseHelper.instance.deleteChallenge,
};

final Map<String, dynamic> _restartAction = {
  'type': 'Restart',
  'do': (challenge) => _updateChallenge(challenge, challenge.restart),
};

final Map<String, dynamic> _failAction = {
  'type': 'Fail',
  'do': (challenge) => _updateChallenge(challenge, challenge.fail),
};

_updateChallenge(Challenge challenge, Function challengeAction) {
  final List<ChallengeDayCompleted> completedDays = [];
  for (final dateCompleted in challenge.datesCompleted()) {
    completedDays.add(ChallengeDayCompleted(challenge.id, dateCompleted));
  }

  challengeAction();

  DatabaseHelper.instance.updateChallenge(challenge);
  DatabaseHelper.instance.insertChallengeDaysCompleted(completedDays);
}
