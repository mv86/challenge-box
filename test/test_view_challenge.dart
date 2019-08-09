import 'package:challenge_box/db/models/challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:challenge_box/view_challenge.dart';
import 'package:mockito/mockito.dart';

Widget createWidgetForTesting(Widget childWidget) {
  return MaterialApp(
    home: childWidget,
  );
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('ChallengePage Widget', () {
    Challenge challenge;
    Widget challengePageWidget;
    // NavigatorObserver mockObserver;

    final _dt = DateTime.now().subtract(Duration(days: 2));
    final startDate = DateTime(_dt.year, _dt.month, _dt.day);

    setUp(() {
      challenge = Challenge('Name', startDate);
      challengePageWidget = ChallengePage(challenge: challenge);
      // mockObserver = MockNavigatorObserver();
    });

    testWidgets('can be instantiated', (WidgetTester tester) async {
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
    });

    testWidgets('can mark Challenge as failed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(challengePageWidget));
      expect(challenge.failed, equals(false));

      await tester.tap(find.byKey(Key('failButton')));
      await tester.pump();

      expect(challenge.failed, equals(true));
    });

    testWidgets('can restart Challenge', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(challengePageWidget));
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      await tester.tap(find.byKey(Key('restartButton')));
      await tester.pump();

      expect(challenge.startDate, equals(today));
    });

    // testWidgets('can delete Challenge', (WidgetTester tester) async {
    //   await tester.pumpWidget(createWidgetForTesting(challengePageWidget));

    //   await tester.tap(find.byKey(Key('deleteButton')));
    //   await tester.pump();

    //   verify(mockObserver.didPop(any, any));

    // expect(currentChallengesPageFinder, findsOneWidget);
    // });
  });
}
