import 'package:flutter/material.dart';

Widget createWidgetForTesting(Widget childWidget) {
  return MaterialApp(
    home: childWidget,
  );
}
