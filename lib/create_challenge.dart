import 'package:flutter/material.dart';
import 'package:challenge_box/db/models/challenge.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CreateChallengePage extends StatefulWidget {
  CreateChallengePage({Key key, @required this.title}) : super(key: key);

  final String title;

   @override
  _CreateChallengePageState createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat("dd-MM-yyyy");
  final _nameController = TextEditingController();
  final _startDateController = TextEditingController();

  String _challengeName;
  DateTime _startDate = DateTime.now();

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
                controller: _nameController,
                decoration: InputDecoration(
                  icon: Icon(Icons.equalizer),
                  labelText: 'Challenge Name',
                  hintText: 'E.g Quit Alcohol',
                ),
                validator: (input) => input.length < 1 ? 'You must choose a challenge name' : null,
                onSaved: (input) => _challengeName = input,
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
                    lastDate: DateTime.now()
                  );
                },
                onSaved: (input) => input is DateTime ? _startDate = input : null,
              ),
              Builder(
                builder: (context) => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              final challenge = Challenge(_challengeName, _startDate);
                              challenge.save();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  '$_challengeName saved', 
                                  style: TextStyle(fontSize: 18.0, color: Colors.teal[100])
                                ),
                              ));
                              _nameController.clear();
                              _startDateController.clear();
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
        )
      )
    );
  }
}
