import 'package:flutter/services.dart';
import 'package:journal/auth/auth.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MoodDetector {
  final _modelFile = 'journal.tflite';
  late Interpreter journalAnalyzer;
  late Map<String, int> _dict;
  final _journaldictfile = 'journal.txt';
  static int line = 256;
  final String start = '<START>';
  final String pad = '<PAD>';
  final String unk = '<UNKNOWN>';

  MoodDetector() {
    journalModel();
    journalDict();
  }

  List<List<double>> tokenizeInputText(String text) {
    final toks = text.split(' ');
    var vec = List<double>.filled(line, _dict[pad]!.toDouble());
    print(vec);
    var index = 0;
    if (_dict.containsKey(start)) {
      vec[index++] = _dict[start]!.toDouble();
    }
    for (var tok in toks) {
      if (index > line) {
        break;
      }
      vec[index++] = _dict.containsKey(tok)
          ? _dict[tok]!.toDouble()
          : _dict[unk]!.toDouble();
    }
    return [vec];
  }

  void journalModel() async {
    journalAnalyzer = await Interpreter.fromAsset('$_modelFile');
    // garuna test case => remove later on
    if (journalAnalyzer.isAllocated) {
      print(1);
    } else {
      print(0);
    }
  }

  void journalDict() async {
    final vocab = await rootBundle.loadString('assets/$_journaldictfile');
    var dict = <String, int>{};
    final vocabList = vocab.split('\n');
    final dictLength = vocabList.length;
    for (var i = 0; i < dictLength; i++) {
      var entry = vocabList[i].trim().split(' ');
      dict[entry[0]] = int.parse(entry[1]);
    }
    _dict = dict;
    if (_dict.isNotEmpty) {
      print(1);
    } else {
      print(0);
    }
  }

  int checkMood(String _text) {
    List<List<double>> input = tokenizeInputText(_text);
    var output = List<double>.filled(2, 0).reshape([1, 2]);
    journalAnalyzer.run(input, output);
    final positive = num.parse(output[0][0].toStringAsFixed(2));
    final negative = num.parse(output[0][1].toStringAsFixed(2));
    print(positive);
    print(negative);
    // happy=> 1, neutal => 0, sad => -1
    if (positive > negative) {
      //double num1 = double.parse((12.3412).toStringAsFixed(2));
      currentUser.coins += double.parse((positive * 3.14).toStringAsFixed(2));
      return 1;
    } else {
      currentUser.coins -= double.parse((negative * 3.14).toStringAsFixed(2));
      return -1;
    }
  }
}

final model = MoodDetector();
