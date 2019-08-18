import 'package:challenge_box/db/connections/challenge_connection.dart';
import 'package:challenge_box/db/connections/challenge_day_completed_connection.dart';
import 'package:challenge_box/db/models/challenge.dart';
import 'package:challenge_box/pages/view_challenge.dart';
import 'package:challenge_box/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../utilities.dart';

class MockChallengeDateConnection extends Mock
    implements ChallengeDayCompletedConnection {}

class MockChallengeConnection extends Mock implements ChallengeConnection {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('ChallengePage Widget', () {
    Challenge challenge;
    Widget challengePageWidget;
    // NavigatorObserver mockObserver;
    MockChallengeConnection mockChallengeConnection;
    MockChallengeDateConnection mockChallengeDateConnection;

    final twoDaysAgo = DateTime.now().subtract(Duration(days: 2));
    final startDate = toDate(twoDaysAgo);

    setUp(() {
      challenge = Challenge('Name', startDate);
      challenge.id = 1;
      challengePageWidget = ChallengePage(
        challenge: challenge,
        challengeConnection: mockChallengeConnection,
        challengeDateConnection: mockChallengeDateConnection,
      );
      // mockObserver = MockNavigatorObserver();
    });
    // TODO Fix why no longer working, to do with using future builder?

    testWidgets('can be instantiated', (WidgetTester tester) async {
      // await tester.runAsync(() async {
      await tester.pumpWidget(createWidgetForTesting(challengePageWidget));

      final titleFinder = find.text('Name');
      final calenderFinder = find.byType(CalendarCarousel);
      final failButtonFinder = find.byKey(Key('failButton'));
      final restartButtonFinder = find.byKey(Key('restartButton'));
      final deleteButtonFinder = find.byKey(Key('deleteButton'));

      expect(titleFinder, findsOneWidget);
      expect(calenderFinder, findsOneWidget);
      expect(failButtonFinder, findsOneWidget);
      expect(restartButtonFinder, findsOneWidget);
      expect(deleteButtonFinder, findsOneWidget);
      // });
    });

    // testWidgets('can mark Challenge as failed', (WidgetTester tester) async {
    //   await tester.pumpWidget(createWidgetForTesting(challengePageWidget));
    //   expect(challenge.failed, equals(false));

    //   await tester.tap(find.byKey(Key('failButton')));
    //   await tester.pump();

    //   await tester.tap(find.byKey(Key('yesButton')));
    //   await tester.pump();

    //   expect(challenge.failed, equals(true));
    // });

    // testWidgets('can restart Challenge', (WidgetTester tester) async {
    //   await tester.pumpWidget(createWidgetForTesting(challengePageWidget));
    //   final today = toDate(DateTime.now());

    //   await tester.tap(find.byKey(Key('restartButton')));
    //   await tester.pump();

    //   await tester.tap(find.byKey(Key('yesButton')));
    //   await tester.pump();

    //   expect(challenge.startDate, equals(today));
    // });

    // testWidgets('can delete Challenge', (WidgetTester tester) async {
    //   await tester.pumpWidget(createWidgetForTesting(challengePageWidget));

    //   await tester.tap(find.byKey(Key('deleteButton')));
    //   await tester.pump();

    //   verify(mockObserver.didPop(any, any));

    // expect(currentChallengesPageFinder, findsOneWidget);
    // });
  });
}
