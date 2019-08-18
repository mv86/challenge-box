import 'package:challenge_box/db/connections/challenge_connection.dart';
import 'package:challenge_box/pages/create_challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../utilities.dart';

class MockConnection extends Mock implements ChallengeConnection {}

void main() {
  group('Create Challenge Page', () {
    CreateChallengePage createChallengePage;
    Finder challengeNameField;
    Finder submitButton;
    MockConnection mockConnection;
    String challengeName;

    setUp(() {
      challengeName = 'Test Challenge 1';
      mockConnection = MockConnection();
      createChallengePage = CreateChallengePage(
        title: 'Test Page',
        currentChallengeNames: [],
        dbConnection: mockConnection,
      );
      challengeNameField = find.widgetWithText(TextFormField, 'Challenge Name');
      submitButton = find.widgetWithText(RaisedButton, 'Create Challenge');
    });
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(createChallengePage));

      expect(find.text('Challenge Name'), findsOneWidget);
      expect(find.text('Challenge Start Date'), findsOneWidget);
      expect(find.text('Create Challenge'), findsOneWidget);
    });

    testWidgets('displays toast on successful creation', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(createChallengePage));

      await tester.enterText(challengeNameField, challengeName);

      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text('$challengeName Created'), findsOneWidget);
    });

    testWidgets('asserts challenge has name', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(createChallengePage));

      await tester.enterText(challengeNameField, '');

      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text('You must choose a challenge name'), findsOneWidget);
    });

    testWidgets('asserts challenge names are alphanumeric', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(createChallengePage));

      await tester.enterText(challengeNameField, '*');

      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text('Challenge names must be alphanumeric'), findsOneWidget);
    });

    testWidgets('asserts challenge names are unique', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(CreateChallengePage(
        title: 'Test Page',
        currentChallengeNames: [challengeName],
        dbConnection: mockConnection,
      )));

      await tester.enterText(challengeNameField, challengeName);

      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text('Challenge already exists'), findsOneWidget);
      expect(find.text('$challengeName Created'), findsNothing);
    });
  });
}
