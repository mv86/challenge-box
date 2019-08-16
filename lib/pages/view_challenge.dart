import 'package:challenge_box/db/connections/challenge_connection.dart';
import 'package:challenge_box/db/connections/challenge_day_completed_connection.dart';
import 'package:challenge_box/db/models/challenge.dart';
import 'package:challenge_box/db/models/challenge_day_completed.dart';
import 'package:challenge_box/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class ChallengePage extends StatefulWidget {
  final Challenge challenge;
  final ChallengeConnection challengeConnection;
  final ChallengeDayCompletedConnection challengeDateConnection;

  ChallengePage({
    Key key,
    @required this.challenge,
    @required this.challengeConnection,
    @required this.challengeDateConnection,
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
          futureAction: widget
              .challengeDateConnection.queryPreviousChallengeDatesCompleted,
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
                onPressed: () => _confirm(
                  'Delete',
                  widget.challenge,
                  context,
                  widget.challengeConnection.deleteChallenge,
                ),
                child: Text('Delete'),
              ),
              RaisedButton(
                key: Key('restartButton'),
                onPressed: () => _confirm(
                  'Restart',
                  widget.challenge,
                  context,
                  () => _updateChallenge(
                    widget.challenge,
                    widget.challenge.restart,
                  ),
                ),
                child: Text('Restart'),
              ),
              RaisedButton(
                key: Key('failButton'),
                onPressed: widget.challenge.failed
                    ? null
                    : () => _confirm(
                          'Fail',
                          widget.challenge,
                          context,
                          () => _updateChallenge(
                            widget.challenge,
                            widget.challenge.fail,
                          ),
                        ),
                child: Text('Fail'),
              ),
            ],
          )
        ],
      ),
    );
  }

  _confirm(actionName, challenge, context, doAction) async {
    final confirmedAction = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('{actionName} ${challenge.name}'),
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
      doAction(challenge);
      Navigator.of(context).pop();
    }
  }

  _updateChallenge(Challenge challenge, Function challengeAction) {
    final List<ChallengeDayCompleted> completedDays = [];
    for (final dateCompleted in challenge.datesCompleted()) {
      completedDays.add(ChallengeDayCompleted(challenge.id, dateCompleted));
    }

    challengeAction();

    widget.challengeConnection.updateChallenge(challenge);
    widget.challengeDateConnection.insertChallengeDaysCompleted(completedDays);
  }
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
