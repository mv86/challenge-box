import 'package:flutter/material.dart';
import 'package:challenge_box/create_challenge.dart';
import 'package:challenge_box/current_challenges.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => CurrentChallengesPage(
          title: 'Current Challenges',
        ));
      case '/createChallenge':
        return MaterialPageRoute(builder: (_) => CreateChallengePage(
          title: 'Create Challenge',
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