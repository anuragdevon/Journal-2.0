// import 'package:flutter/services.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'dart:async';

// // bas yaha garuna wala kaam kiya hain
// var coins; // this will be updated once in a day => call a function at some particular time to update this paramter
// var result;
// var positives;
// var negetives;

// class MoodDetector {
//   final _modelFile = 'journal.tflite';
//   late Interpreter journalAnalyzer;
//   late Map<String, int> _dict;
//   final _journaldictfile = 'journal.txt';
//   static int line = 256;
//   final String start = '<START>';
//   final String pad = '<PAD>';
//   final String unk = '<UNKNOWN>';
//   final _userFile = 'usertext.txt';

//   MoodDetector() {
//     journalModel();
//     journalDict();
//     loadAsset();
//   }

//   Future<String> loadAsset() async {
//     return await rootBundle.loadString('$_userFile');
//   }

//   List<List<double>> tokenizeInputText(String text) {
//     final toks = text.split(' ');
//     var vec = List<double>.filled(line, _dict[pad]!.toDouble());
//     print(vec);
//     var index = 0;
//     if (_dict.containsKey(start)) {
//       vec[index++] = _dict[start]!.toDouble();
//     }
//     for (var tok in toks) {
//       if (index > line) {
//         break;
//       }
//       vec[index++] = _dict.containsKey(tok)
//           ? _dict[tok]!.toDouble()
//           : _dict[unk]!.toDouble();
//     }
//     return [vec];
//   }

//   void journalModel() async {
//     journalAnalyzer = await Interpreter.fromAsset('$_modelFile');
//     // garuna test case => remove later on
//     if (journalAnalyzer.isAllocated) {
//       print(1);
//     } else {
//       print(0);
//     }
//   }

//   void journalDict() async {
//     final vocab = await rootBundle.loadString('assets/$_journaldictfile');
//     var dict = <String, int>{};
//     final vocabList = vocab.split('\n');
//     final dictLength = vocabList.length;
//     for (var i = 0; i < dictLength; i++) {
//       var entry = vocabList[i].trim().split(' ');
//       dict[entry[0]] = int.parse(entry[1]);
//     }
//     _dict = dict;
//     // garuna test case => remove later on
//     if (_dict.isNotEmpty) {
//       print(1);
//     } else {
//       print(0);
//     }
//   }

//   int checkMood(String userData) {
//     List<List<double>> input = tokenizeInputText(userData);
//     var output = List<double>.filled(2, 0).reshape([1, 2]);
//     journalAnalyzer.run(input, output);
//     //return [output[0][0], output[0][1]];
//     final positive = output[0][0];
//     final negetive = output[0][1];
//     // happy=> 1, neutal => 0, sad => -1
//     if (positive > negetive) {
//       return 1;
//     } else if (positive > 0.45 && positive < 0.55) {
//       return 0;
//     } else
//       return -1;
//   }

//   double coinsGenerator(int counter) {
//     double coins = double.parse((counter * 3.14).toStringAsFixed(2));
//     return coins;
//   }
// }
