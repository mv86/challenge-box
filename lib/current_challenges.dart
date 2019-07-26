import 'package:flutter/material.dart';
import 'package:challenge_box/db/database_helper.dart';

class CurrentChallengesPage extends StatefulWidget {
  CurrentChallengesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CurrentChallengesPageState createState() => _CurrentChallengesPageState();
}

class _CurrentChallengesPageState extends State<CurrentChallengesPage> {
  Widget _displayCurrentChallenges() {
    return FutureBuilder(
      future: DatabaseHelper.instance.queryCurrentChallenges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return new Text(
              '${snapshot.error}', 
              style: TextStyle(color: Colors.red)
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var challenge = snapshot.data[index];
                return Container (
                  color: (index % 2 == 0 ) ? Colors.grey[800] : Colors.grey[850],
                  child: ListTile(
                    title: Text(challenge.name, style: TextStyle(fontSize: 28.0)),
                    subtitle: Text(challenge.stats(), style: TextStyle(fontSize: 18.0)),
                    trailing: challenge.failed ? Icon(Icons.error, color: Colors.red) : null,
                    onTap: () => challenge.failed ? _showRestartDialog(context, challenge) : _showFailedDialog(context, challenge),
                  )
                );
              },
            );
          }
        } else {
        return new Center(child: new CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _displayCurrentChallenges(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           Navigator.of(context).pushNamed('/createChallenge');
        },
        tooltip: 'Increment',
        icon: Icon(Icons.add),
        label: Text('Create New Challenge')
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
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
                _failChallenge(challenge);

                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/');
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
                _restartChallenge(challenge);

                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/');
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () async {
                await DatabaseHelper.instance.deleteChallenge(challenge);
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

_failChallenge(challenge) async {
  challenge.failed = true;
  if (challenge.daysCompleted() > challenge.longestDuration) {
    challenge.longestDuration = challenge.daysCompleted();
  }
  challenge.startDate = DateTime.now();

  await DatabaseHelper.instance.updateChallenge(challenge);
}

_restartChallenge(challenge) async {
  challenge.failed = false;
  challenge.startDate = DateTime.now();

  await DatabaseHelper.instance.updateChallenge(challenge);
}
