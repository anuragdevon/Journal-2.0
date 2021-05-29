import 'dart:io';
import 'package:flutter/material.dart';
import 'package:journal/auth/auth.dart';
import 'package:journal/journal.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'journal.dart';
import 'main.dart';
import 'profile.dart';
import 'shop.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(child: DrawerHeader(child: Text(MyApp.name))),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, Profile.id);
            },
          ),
          ListTile(
              title: Text('Shop'),
              onTap: () {
                Navigator.pushNamed(context, Shop.id);
              })
        ],
      ),
    );
  }
}

class Journal extends StatefulWidget {
  final DateTime date;
  final String text;

  Journal({Key? key, required this.date, required this.text}) : super(key: key);

  static Future<Journal> load(File journal) async {
    final String fileName = path.basename(journal.path).split('.').first;
    final DateTime date = DateTime.parse(fileName);
    return Journal(date: date, text: await journal.readAsString());
  }

  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(Jiffy(widget.date).format('MMM d, yyyy')),
        subtitle: Text(widget.text),
        trailing: Icon(Icons.emoji_emotions),
        onTap: () {
          Navigator.pushNamed(
            context,
            JournalInput.id,
            arguments: JournalInputArguments(
                date: this.widget.date, text: this.widget.text),
          );
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  static const String id = '/';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const maxhistoryLength = 10;

  List<String> _searchHistory = [];

  List<String> filteredSearchHistory = [];
  String? selectedTerm;

  List<String> filterSearchTerms({String? filter}) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      // putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > maxhistoryLength) {
      _searchHistory.removeRange(0, _searchHistory.length - maxhistoryLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController? controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  searchBarAction() {
    if (selectedTerm == null)
      return [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(picture ?? ''),
            ),
            onPressed: () {
              Navigator.pushNamed(context, Profile.id);
            },
          ),
        ),
        // FloatingSearchBarAction.searchToClear()
      ];
    return [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            setState(() {
              selectedTerm = null;
            });
          },
        ),
      ),
    ];
  }

  getSearchBarTitle() {
    if (selectedTerm != null) {
      return Text(selectedTerm.toString());
    }
    return null;
  }

  Widget buildFloatingSearchBar() {
    final isPortrait = true;

    return FloatingSearchBar(
      controller: controller,
      body: FloatingSearchBarScrollNotifier(
        child: JournalList(selectedTerm: selectedTerm),
      ),
      title: getSearchBarTitle(),
      hint: "Search your journals",
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 16),
      transitionDuration: const Duration(milliseconds: 150),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 10),
      onQueryChanged: (query) {
        setState(() {
          filteredSearchHistory = filterSearchTerms(filter: query);
        });
      },
      onSubmitted: (query) {
        setState(() {
          addSearchTerm(query);
          selectedTerm = query;
        });
        controller!.close();
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: searchBarAction(),
      builder: searchBarBodyBuilder,
    );
  }

  Widget searchBarBodyBuilder(context, transition) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        elevation: 4,
        child: Builder(
          builder: (context) {
            if (filteredSearchHistory.isEmpty && controller!.query.isEmpty) {
              return Container(
                height: 56,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Start searching',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              );
            } else if (filteredSearchHistory.isEmpty) {
              return ListTile(
                title: Text(controller!.query),
                leading: const Icon(Icons.search),
                onTap: () {
                  setState(() {
                    addSearchTerm(controller!.query);
                    selectedTerm = controller!.query;
                  });
                  controller!.close();
                },
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: filteredSearchHistory
                    .map(
                      (term) => ListTile(
                        title: Text(
                          term,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: const Icon(Icons.history),
                        trailing: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              deleteSearchTerm(term);
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            putSearchTermFirst(term);
                            selectedTerm = term;
                          });
                          controller!.close();
                        },
                      ),
                    )
                    .toList(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> loadTodaysJournalText() async {
    String contents = '';
    final String journalID = Jiffy(DateTime.now()).format('yyyyMMdd');
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    try {
      final file = File('$path/$journalID.txt');
      contents = await file.readAsString();
    } catch (e) {}
    final _ = await Navigator.pushNamed(
      context,
      JournalInput.id,
      arguments: JournalInputArguments(text: contents),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildFloatingSearchBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: loadTodaysJournalText,
        child: const Icon(Icons.add),
      ),
      drawer: Sidebar(),
    );
  }
}

class JournalList extends StatefulWidget {
  final String? selectedTerm;

  JournalList({Key? key, this.selectedTerm}) : super(key: key);

  @override
  _JournalListState createState() => _JournalListState();
}

class _JournalListState extends State<JournalList> {
  @override
  Widget build(BuildContext context) {
    print('tif');
    return FutureBuilder(
      future: MyApp.journalsLoaded,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return journalList(MyApp.journals);
        }
        return ListTile(title: Text('Loading'));
      },
    );
  }

  Widget journalList(searchInput) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 96, 8, 0),
      itemExtent: 80.0,
      children: searchInput
          .where((Journal journal) => journal.text.toLowerCase().contains(
              widget.selectedTerm != null
                  ? widget.selectedTerm.toString().toLowerCase()
                  : ''))
          .toList(),
    );
  }
}
