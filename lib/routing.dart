import 'package:flutter/material.dart';
import 'main.dart';
import 'journalinput.dart';
import 'profile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    const String homeID = '/';
    const String jouranlInputID = '/journalInput';
    const String profileID = '/profile';

    switch (settings.name) {
      case homeID:
        return MaterialPageRoute(builder: (context) => Home());
      case jouranlInputID:
        final args = settings.arguments as JournalInputArguments;
        return MaterialPageRoute(
            builder: (context) => JournalInput(journalText: args.journalText));
      case profileID:
        return MaterialPageRoute(builder: (context) => Profile());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
