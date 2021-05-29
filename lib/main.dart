import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'routing.dart';
import 'home.dart';
import 'auth/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const name = 'Journals';
  static final List<Journal> journals = [];
  static final journalsLoaded = loadJournals();

  static Future<bool> loadJournals() async {
    final Directory dataDir = await getApplicationDocumentsDirectory();
    await for (FileSystemEntity journal in dataDir.list(
      recursive: false,
      followLinks: false,
    )) {
      if (journal is File && journal.path.endsWith('.txt')) {
        journals.add(await Journal.load(journal));
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Login.id,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
