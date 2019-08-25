import 'package:challenge_box/db/connections/challenge_connection.dart';
import 'package:challenge_box/utilities.dart';
import 'package:flutter/material.dart';
import 'package:challenge_box/db/models/challenge.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CreateChallengePage extends StatefulWidget {
  final String title;
  final List<String> currentChallengeNames;
  final ChallengeConnection dbConnection;

  CreateChallengePage({
    Key key,
    @required this.title,
    @required this.currentChallengeNames,
    @required this.dbConnection,
  }) : super(key: key);

  @override
  _CreateChallengePageState createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat("dd/MM/yyyy");
  final _nameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime _tomorrow = DateTime.now().add(Duration(days: 1));
  Duration _oneHundredYears = Duration(days: 36500);

  String _challengeName;
  bool _timedChallenge = false;
  DateTime _startDate = DateTime.now();
  DateTime _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 2.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.text_format),
                    labelText: 'Challenge Name',
                    hintText: 'E.g. Do Not Smoke',
                  ),
                  validator: (name) =>
                      _validateName(ReCase(name).titleCase.trim()),
                  onSaved: (name) => setState(
                    () => _challengeName = ReCase(name).titleCase.trim(),
                  ),
                ),
                DateTimeField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: 'Challenge Start Date',
                  ),
                  format: _dateFormat,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(2018),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime.now());
                  },
                  onSaved: (input) => setState(
                    () => input is DateTime ? _startDate = input : null,
                  ),
                ),
                DateTimeField(
                  enabled: _timedChallenge ? true : false,
                  controller: _endDateController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: 'Challenge End Date',
                  ),
                  format: _dateFormat,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                      context: context,
                      firstDate: _tomorrow,
                      initialDate: currentValue ?? _tomorrow,
                      lastDate: DateTime.now().add(_oneHundredYears),
                    );
                  },
                  onSaved: (input) => setState(
                    () => input is DateTime ? _endDate = input : null,
                  ),
                ),
                CheckboxListTile(
                  title: Text(
                    'Set Challenge End Date?',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  value: _timedChallenge,
                  onChanged: (value) => setState(() => _timedChallenge = value),
                ),
                Builder(
                  builder: (context) => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _saveChallenge(widget.dbConnection);
                              _showSnackBar(context);
                            }
                          },
                          child: Text('Create Challenge'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateName(String name) {
    var nonAlphaNumericRegex = RegExp('[^0-9a-zA-Z ]');

    if (name.length < 1) {
      return 'You must choose a challenge name';
    }
    if (nonAlphaNumericRegex.firstMatch(name) != null) {
      return 'Challenge names must be alphanumeric';
    }
    if (widget.currentChallengeNames.contains(name)) {
      return 'Challenge already exists';
    }

    return null;
  }

  _saveChallenge(dbConnection) {
    _formKey.currentState.save();
    Challenge challenge;

    if (_endDate == null) {
      challenge = Commitment(
        name: _challengeName,
        startDate: toDate(_startDate),
      );
    } else {
      challenge = ShortTerm(
        name: _challengeName,
        startDate: toDate(_startDate),
        endDate: toDate(_endDate),
      );
    }

    dbConnection.insertChallenge(challenge);

    _nameController.clear();
    _startDateController.clear();
    _endDateController.clear();
    setState(() => _timedChallenge = false);
  }

  _showSnackBar(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$_challengeName Created',
          style: TextStyle(fontSize: 18.0, color: Colors.teal[100]),
        ),
      ),
    );
  }
}
