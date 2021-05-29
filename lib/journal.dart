import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:journal/main.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'home.dart';

class JournalInput extends StatefulWidget {
  static const String id = '/journalInput';
  late final String text;
  late final DateTime date;

  JournalInput({DateTime? date, String? text, Key? key}) : super(key: key) {
    this.text = text == null ? '' : text;
    this.date = date == null ? DateTime.now() : date;
  }

  @override
  _JournalInputState createState() => _JournalInputState();
}

class _JournalInputState extends State<JournalInput> {
  String journalText = '';

  Future<bool> _backButtonPressed() async {
    // TODO: handle list updation on pop
    final String journalId = Jiffy(widget.date).format('yyyyMMdd');

    final Directory directory = Platform.isLinux
        ? Directory('/home/subaru/.cache/journals')
        : await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$journalId.txt');
    file.writeAsString('$journalText');
    MyApp.journals.removeWhere((journal) => journal.date == widget.date);
    MyApp.journals.add(Journal(date: widget.date, text: journalText));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final String formatted = Jiffy(widget.date).format('MMM dd, yyyy');
    final String formattedTime = Jiffy(widget.date).jm;
    journalText = widget.text;

    final dateBox = Container(
      child: Text(
        formatted,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
      ),
    );
    final writeBox = Container(
      child: TextFormField(
        initialValue: journalText,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          hintText: "write...",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          journalText = value;
          value = journalText;
        },
      ),
    );
    final lastUpdated = Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          "Last Saved: $formattedTime",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: WillPopScope(
        onWillPop: _backButtonPressed,
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 32, 8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  dateBox,
                  Expanded(child: writeBox),
                  lastUpdated,
                ]),
          ),
        ),
      ),
    );
  }
}

class JournalInputArguments {
  late final String text;
  late final DateTime date;

  JournalInputArguments({DateTime? date, String? text}) {
    this.text = text == null ? '' : text;
    this.date = date == null ? DateTime.now() : date;
  }
}
