import 'package:challenge_box/db/connections/challenge_connection.dart';
import 'package:challenge_box/db/models/challenge.dart';
import 'package:challenge_box/pages/create_challenge.dart';
import 'package:challenge_box/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../utilities.dart';

class MockConnection extends Mock implements ChallengeConnection {}

void main() {
  group('View Challenge Widget', () {
    CreateChallengePage createChallengePage;
    Finder challengeNameField;
    Finder submitButton;
    MockConnection mockConnection;
    String challengeName;
    DateTime startDate;
    Challenge challenge;

    setUp(() {
      mockConnection = MockConnection();
      createChallengePage = CreateChallengePage(
        title: 'Test Page',
        dbConnection: mockConnection,
      );
      challengeName = 'Test Challenge';
      startDate = toDate(DateTime.now());
      challenge = Challenge(challengeName, startDate);
      challengeNameField = find.widgetWithText(TextFormField, 'Challenge Name');
      submitButton = find.widgetWithText(RaisedButton, 'Create Challenge');
    });
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(createChallengePage));

      expect(find.text('Challenge Name'), findsOneWidget);
      expect(find.text('Challenge Start Date'), findsOneWidget);
      expect(find.text('Create Challenge'), findsOneWidget);
    });

    testWidgets('displays toast on created challenge', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(createChallengePage));

      when(mockConnection.insertChallenge(challenge))
          .thenAnswer((_) async => 1);

      await tester.enterText(challengeNameField, challengeName);

      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text('$challengeName Created'), findsOneWidget);
    });

    testWidgets('only allows unique challenge names', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(createChallengePage));

      when(mockConnection.insertChallenge(challenge))
          .thenAnswer((_) async => null);

      await tester.enterText(challengeNameField, challengeName);

      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text('$challengeName Created'), findsNothing);
      expect(find.text('$challengeName already exists'), findsOneWidget);
    });
  });
}
