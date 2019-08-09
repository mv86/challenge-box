import 'package:flutter/material.dart';
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
        body: Builder(builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: CalendarCarousel(
                    thisMonthDayBorderColor: Colors.grey,
                    height: 420.0,
                    selectedDateTime: DateTime.now(),
                    daysHaveCircularBorder: false,
                    // markedDatesMap: _markedDateMap,
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
                      onPressed: () =>
                          _confirm(_failAction, widget.challenge, context),
                      child: Text('Fail'),
                    ),
                  ],
                )
              ],
            ),
          );
        }));
  }

  final Map<String, dynamic> _deletAction = {
    'type': 'Delete',
    'do': DatabaseHelper.instance.deleteChallenge,
    'toNavigateAway': true,
  };

  final Map<String, dynamic> _restartAction = {
    'type': 'Restart',
    'do': (challenge) {
      challenge.restart();
      DatabaseHelper.instance.updateChallenge(challenge);
    },
    'toNavigateAway': false,
  };

  final Map<String, dynamic> _failAction = {
    'type': 'Fail',
    'do': (challenge) {
      challenge.fail();
      DatabaseHelper.instance.updateChallenge(challenge);
    },
    'toNavigateAway': false,
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

      if (action['toNavigateAway']) {
        Navigator.of(context).pop();
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('${challenge.name} ${action['type']}ed',
              style: TextStyle(fontSize: 18.0, color: Colors.teal[100])),
        ));
      }
    }
  }
}
