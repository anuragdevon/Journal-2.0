import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JournalInput extends StatefulWidget {
  static String id = '/journalInput';
  final String journalText;

  const JournalInput({
    this.journalText = "",
    Key? key,
  }) : super(key: key);

  @override
  _JournalInputState createState() => _JournalInputState();
}

class _JournalInputState extends State<JournalInput> {
  String journalText = "";
  String journalId = Jiffy(DateTime.now()).format("yyyymmdd");

  Future<bool> _backButtonPressed() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$journalId.txt');
    file.writeAsString('$journalText');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final String formatted = Jiffy(DateTime.now()).format("dd MMMM yyyy");
    final String formattedTime = Jiffy(DateTime.now()).jm;
    journalText = this.widget.journalText;

    final dateBox = Container(
      child: Text(
        formatted,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 20,
              color: Colors.black54,
            ),
      ),
    );
    final writeBox = Container(
      child: TextFormField(
        initialValue: journalText,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 16,
              color: Colors.black54,
            ),
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
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 12,
                color: Colors.black54,
              ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("A few handy buttons here"),
      ),
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
  final String journalText;

  JournalInputArguments(this.journalText);
}
