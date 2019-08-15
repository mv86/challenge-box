import 'package:flutter/material.dart';
import 'package:challenge_box/route_generator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge Box',
      theme: ThemeData.dark(),
      initialRoute: AppRoute.currentChallenges,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
