import 'package:flutter/material.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'TODO',
            ),
          ],
        ),
      ),
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
