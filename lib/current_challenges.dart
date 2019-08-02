import 'package:flutter/material.dart';
import 'package:challenge_box/db/database_helper.dart';
import 'package:challenge_box/route_generator.dart';

class CurrentChallengesPage extends StatefulWidget {
  CurrentChallengesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CurrentChallengesPageState createState() => _CurrentChallengesPageState();
}

class _CurrentChallengesPageState extends State<CurrentChallengesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _displayCurrentChallenges(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.of(context).pushNamed(AppRoute.createChallenge);
        },
        child: Icon(Icons.add),
        tooltip: 'Create New Challenge',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Widget _displayCurrentChallenges() {
  return FutureBuilder(
    future: DatabaseHelper.instance.queryCurrentChallenges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return new Text('${snapshot.error}', style: TextStyle(color: Colors.red));
        } else {
          return _currentChallenges(snapshot);
        }
      } else {
      return new Center(child: new CircularProgressIndicator());
      }
    },
  );
}

_currentChallenges(challenges) {
  return ListView.builder(
    padding: EdgeInsets.all(8.0),
    itemCount: challenges.data.length,
    itemBuilder: (BuildContext context, int index) {
      var challenge = challenges.data[index];
      return Container (
        color: (index % 2 == 0 ) ? Colors.grey[800] : Colors.grey[850],
        child: ListTile(
          title: Text(
            challenge.name,
            style: TextStyle(fontSize: 28.0)
          ),
          subtitle: Text(
            challenge.stats(),
            style: TextStyle(fontSize: 18.0)
          ),
          trailing: challenge.failed ? Icon(Icons.error, color: Colors.red) : null,
          onTap: () => challenge.failed ? _showRestartDialog(context, challenge) : _showFailedDialog(context, challenge),
        )
      );
    },
  );
}

_showFailedDialog(context, challenge) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('${challenge.name}'),
          content: new Text('Mark as failed?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                challenge.fail();
                DatabaseHelper.instance.updateChallenge(challenge);
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoute.currentChallenges);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

_showRestartDialog(context, challenge) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('${challenge.name}'),
          content: new Text('Restart or delete this challenge?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Restart'),
              onPressed: () {
                challenge.restart();
                DatabaseHelper.instance.updateChallenge(challenge);
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoute.currentChallenges);
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                DatabaseHelper.instance.deleteChallenge(challenge);
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoute.currentChallenges);
              },
            ),
          ],
        );
      },
    );
  }
