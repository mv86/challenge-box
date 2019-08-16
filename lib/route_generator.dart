import 'package:challenge_box/db/connections/challenge_connection.dart';
import 'package:challenge_box/db/connections/challenge_day_completed_connection.dart';
import 'package:challenge_box/pages/create_challenge.dart';
import 'package:challenge_box/pages/current_challenges.dart';
import 'package:challenge_box/pages/view_challenge.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const currentChallenges = '/';
  static const createChallenge = '/createChallenge';
  static const challenge = '/challenge';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map<String, dynamic> args = settings.arguments;

    switch (settings.name) {
      case AppRoute.currentChallenges:
        return MaterialPageRoute(
            builder: (_) => CurrentChallengesPage(
                  title: 'Current Challenges',
                  dbConnection: ChallengeConnection(),
                ));
      case AppRoute.createChallenge:
        return MaterialPageRoute(
            builder: (_) => CreateChallengePage(
                  title: 'Create Challenge',
                  dbConnection: ChallengeConnection(),
                ));
      case AppRoute.challenge:
        return MaterialPageRoute(
            builder: (_) => ChallengePage(
                  challenge: args['challenge'],
                  challengeConnection: ChallengeConnection(),
                  challengeDateConnection: ChallengeDayCompletedConnection(),
                ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
