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
                return ListTile(
                  title: Text(
                    snapshot.data[index].name, 
                    style: TextStyle(fontSize: 32.0),
                  ),
                  subtitle: Text(
                    _daysCompleted(snapshot.data[index].startDate),
                    style: TextStyle(fontSize: 18.0),
                  ),
                  trailing: snapshot.data[index].failed ? Icon(Icons.error, color: Colors.red) : null,
                  onTap: () => _showDialog(context, snapshot.data[index].name),
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

_daysCompleted(DateTime startDate) {
  final noOfDays = DateTime.now().difference(startDate).inDays;
  return '$noOfDays days completed';
}

_showDialog(context, challengeName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('$challengeName'),
          content: new Text('Mark as failed?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
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
