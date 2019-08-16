import 'package:challenge_box/db/connections/challenge_connection.dart';
import 'package:challenge_box/pages/create_challenge.dart';
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

    setUp(() {
      mockConnection = MockConnection();
      createChallengePage = CreateChallengePage(
        title: 'Test Page',
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

    testWidgets('displays toast on created challenge', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(createChallengePage));

      await tester.enterText(challengeNameField, 'Test Challenge');

      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text('Test Challenge Created'), findsOneWidget);
    });

    testWidgets('only allows unique challenge names', (tester) async {
      // expect(await fetchPost(client), isInstanceOf<Post>());
      await tester.pumpWidget(createWidgetForTesting(createChallengePage));

      await tester.enterText(challengeNameField, 'Test Challenge');

      when(mockConnection.queryChallengeNames())
          .thenAnswer((_) async => ['Test Challenge']);

      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text('Test Challenge Created'), findsNothing);
      expect(find.text('Challenge name already exists'), findsOneWidget);
    });
  });
}
