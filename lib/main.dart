import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:jiffy/jiffy.dart';
// --> atharva
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const _name = 'Journals';

  // load todays journal -- atharva
  final String journalId = Jiffy(DateTime.now()).format('yyyymmdd');
  Future<bool> loadTodaysJournalText() async {
    String contents = "";
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    try {
      final file = File('$path/$journalId.txt');
      contents = await file.readAsString();
    } catch (e) {}
    final _ = await Navigator.pushNamed(
      context,
      JournalInput.id,
      arguments: JournalInputArguments(contents),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Inconsolata',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: Scaffold(
        // This is handled by the search bar itself.
        resizeToAvoidBottomInset: false,
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          itemExtent: 106.0,
          children: [
            buildFloatingSearchBar(),
            Journal(date: DateTime.utc(2021, 1, 2), text: 'Garuna'),
            Journal(date: DateTime.utc(2021, 2, 3), text: 'is'),
            Journal(date: DateTime.utc(2021, 3, 4), text: 'stupid.'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                  constraints: BoxConstraints.expand(
                    height: Theme.of(context).textTheme.headline2!.fontSize!,
                  ),
                  child: DrawerHeader(
                      child: Text(
                    _name,
                  ))),
              ListTile(
                title: Text('Item 1'),
                onTap: () {},
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    // TODO: Handle landscape
    final isPortrait = true;
    final avatar =
        'https://bitbanged.com/authors/utkarsh/avatar_hu6977ca6bf049ef0aac189df3d30e3e26_225274_270x270_fill_q90_lanczos_center.jpeg';

    return FloatingSearchBar(
      hint: 'Search your journals',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 16),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(avatar),
            ),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class Journal extends StatelessWidget {
  final DateTime date;
  final String text;

  Journal({Key? key, required this.date, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
            title: Text(Jiffy(date).format('MMM d, yyyy')),
            subtitle: Text(text),
            trailing: Icon(Icons.emoji_emotions)),
      );
}
