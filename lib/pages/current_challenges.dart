import 'package:challenge_box/db/connections/challenge_connection.dart';
import 'package:challenge_box/utilities.dart';
import 'package:flutter/material.dart';
import 'package:challenge_box/route_generator.dart';

class CurrentChallengesPage extends StatefulWidget {
  CurrentChallengesPage({
    Key key,
    @required this.title,
    @required this.dbConnection,
  }) : super(key: key);

  final String title;
  final ChallengeConnection dbConnection;

  @override
  _CurrentChallengesPageState createState() => _CurrentChallengesPageState();
}

class _CurrentChallengesPageState extends State<CurrentChallengesPage> {
  List<String> _currentChallengeNames;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 58.0,
            child: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  child: Text(
                    'Continuous',
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                Tab(
                  child: Text(
                    'Timed',
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            futureBuilderWrapper(
              child: _currentChallenges,
              futureAction: widget.dbConnection.queryContinuousChallenges,
            ),
            futureBuilderWrapper(
              child: _currentChallenges,
              futureAction: widget.dbConnection.queryTimedChallenges,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              AppRoute.createChallenge,
              arguments: {
                'currentChallengeNames': _currentChallengeNames,
              },
            );
          },
          child: Icon(Icons.add),
          tooltip: 'Create New Challenge',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  _currentChallenges(challenges) {
    _currentChallengeNames = [...challenges.map((challenge) => challenge.name)];

    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: challenges.length,
      itemBuilder: (BuildContext context, int index) {
        var challenge = challenges[index];
        return Container(
          color: (index % 2 == 0)
              ? Color.fromRGBO(12, 12, 12, 0.00)
              : Color.fromRGBO(12, 12, 12, 0.10),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
              child: ListTile(
                leading: challenge.failed
                    ? Icon(Icons.error, color: Colors.red)
                    : (challenge.isTimed()
                        ? Icon(Icons.timer)
                        : Icon(Icons.timer_off)),
                title: Text(challenge.name, style: TextStyle(fontSize: 28.0)),
                subtitle:
                    Text(challenge.stats(), style: TextStyle(fontSize: 18.0)),
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoute.challenge,
                  arguments: {'challenge': challenge},
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
