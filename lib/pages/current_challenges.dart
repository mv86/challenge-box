import 'package:challenge_box/utility_functions.dart';
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
      body: futureBuilderWrapper(
        child: _currentChallenges,
        futureAction: DatabaseHelper.instance.queryCurrentChallenges,
      ),
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

_currentChallenges(challenges) {
  return ListView.builder(
    padding: EdgeInsets.all(8.0),
    itemCount: challenges.length,
    itemBuilder: (BuildContext context, int index) {
      var challenge = challenges[index];
      return Container(
          color: (index % 2 == 0) ? Colors.grey[800] : Colors.grey[850],
          child: ListTile(
            title: Text(challenge.name, style: TextStyle(fontSize: 28.0)),
            subtitle: Text(challenge.stats(), style: TextStyle(fontSize: 18.0)),
            trailing:
                challenge.failed ? Icon(Icons.error, color: Colors.red) : null,
            onTap: () => Navigator.of(context).pushNamed(
              AppRoute.challenge,
              arguments: {'challenge': challenge},
            ),
          ));
    },
  );
}
