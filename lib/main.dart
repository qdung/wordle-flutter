import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wordle_live_coding/model.dart';

import 'api.dart';

void main() {
  runApp(const MainApp());
}

enum MatchType { absent, present, correct }

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MainApp> {
  final textEditingController = TextEditingController();

  final repository = ApiNetwork();
  List<APIResponse> result = [];
  String word = '';

  String generateRandomNumber(int length) {
    final random = Random();
    String randomNumber = '';
    for (int i = 0; i < length; i++) {
      randomNumber += random.nextInt(10).toString();
    }
    return randomNumber;
  }

  void guessWord() async {
    final seed = generateRandomNumber(4);
    try {
      final data = await repository.guessRandomWord(word, seed);
      if (data != null) {
        setState(() {
          result = data;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text("Wordle live coding"),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: PinCodeTextField(
                    length: 5,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.blue.shade50,
                    enableActiveFill: true,
                    controller: textEditingController,
                    onCompleted: (v) {
                      setState(() {
                        word = v;
                      });
                    },
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  ),
                ),
                ElevatedButton(
                    onPressed: word.length == 5 ? guessWord : null,
                    child: Text("Submit")),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: result
                      .map((element) =>
                          _buildCell(element.guess!, element.result!))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(String cellData, String match) {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.only(right: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: match == 'correct'
            ? Colors.green
            : match == 'present'
                ? Colors.amber
                : Colors.grey,
      ),
      child: Text(cellData,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
