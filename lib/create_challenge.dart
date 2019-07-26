import 'package:flutter/material.dart';
import 'package:challenge_box/db/models/challenge.dart';
import 'package:challenge_box/db/database_helper.dart';

class CreateChallengePage extends StatefulWidget {
  CreateChallengePage({Key key, @required this.title}) : super(key: key);

  final String title;

   @override
  _CreateChallengePageState createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final _formKey = GlobalKey<FormState>();

  String _challengeName;
  DateTime _startDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.equalizer),
                  labelText: 'Challenge Name',
                  hintText: 'E.g Quit Alcohol',
                ),
                validator: (input) => input.length < 4 ? 'Name must be greater than 4' : null,
                onSaved: (input) => _challengeName = input,
               ),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: 'Start Date',
                  hintText: 'Format: DD/MM/YYYY',
                ),
                keyboardType: TextInputType.datetime,
                validator: (input) => input != '' && !_validDate(input) ? 'Valid date format: DD/MM/YYYY' : null,
                onSaved: (input) => input != '' ?
                  _startDate = DateTime.parse(_validFormat(input)) : _startDate = DateTime.now(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _saveChallenge(_challengeName, _startDate);
                        }
                      },
                      child: Text('Create Challenge'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}

_saveChallenge(name, startDate) async {
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  Challenge challenge = Challenge();
  challenge.name = name;
  challenge.startDate = startDate;
  int id = await dbHelper.insert(challenge);
  print('Inserted challenge: id = $id');
}

_validFormat(date) {
  RegExp nonDigit = RegExp(r'\D');
  List<String> dateComponents = date.split(nonDigit);
  return dateComponents[2] + dateComponents[1] + dateComponents[0];
}

_validDate(date) {
  RegExp reDate = RegExp(r'\d{2}\W\d{2}\W\d{4}');
  if (date.length == 10 && reDate.hasMatch(date)) {
    // TODO Add checks for day month etc
    return true;
  }
  return false;
}
