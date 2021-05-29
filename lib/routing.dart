import 'package:flutter/material.dart';
import 'package:journal/auth/auth.dart';
import 'home.dart';
import 'journal.dart';
import 'profile.dart';
import 'auth/login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Home.id:
        return MaterialPageRoute(builder: (context) => Home());
      case Login.id:
        return MaterialPageRoute(builder: (context) => JournalApp());
      case JournalInput.id:
        final args = settings.arguments as JournalInputArguments;
        return MaterialPageRoute(
            builder: (context) => JournalInput(
                  text: args.text,
                  date: args.date,
                ));
      case Profile.id:
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
