import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quizapp/model.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Quiz App by Bikash",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //FOR QUIZ LIST

  List<Quiz> quizes = [];
  int score = 0;
  int currentQuestion = 0;

  //RESET
  void reset() {
    setState(() {
      score = 0;
      currentQuestion = 0;
    });
  }

  //CHECK ANSWER
  void checkAnswer(int userChoice) {
    setState(() {
      if (quizes[currentQuestion].CorrectOption == userChoice) {
        score++;
      }
      if (currentQuestion == quizes.length - 1) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Final Result"),
                  content: Text("Your score: $score"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          reset();
                        },
                        child: Text("Play Again"))
                  ],
                ));
        return;
      }
      currentQuestion++;
    });
  }

  //GET DATA FROM API
  Future getData() async {
    String url =
        "http://192.168.1.73/v1/databases/641a9f0d4855ded3fcca/collections/641a9f2c5a76c3471547/documents";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'X-Appwrite-Project': '641a9ebd560c4464c98b'
    });

    if (response.statusCode == 200) {
      setState(() {
        for (var item in jsonDecode(response.body)["documents"]) {
          quizes.add(Quiz(item["Title"], item["Option_1"], item["Option_2"],
              item["Option_3"], item["Option_4"], item["CorrectOption"]));
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          reset();
        },
        child: Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //FOR QUESTION
            Text(
              "${currentQuestion + 1} out of ${quizes.length}",
              style: TextStyle(fontSize: 17),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(5)),
                height: 100,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Q. ${quizes[currentQuestion].Title}",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: MaterialButton(
                  color: Colors.lightGreen,
                  minWidth: double.infinity,
                  onPressed: () {
                    checkAnswer(1);
                  },
                  child: Text(
                    "A. ${quizes[currentQuestion].Option_1}",
                    style: TextStyle(fontSize: 20),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: MaterialButton(
                  color: Colors.lightGreen,
                  minWidth: double.infinity,
                  onPressed: () {
                    checkAnswer(2);
                  },
                  child: Text(
                    "B. ${quizes[currentQuestion].Option_2}",
                    style: TextStyle(fontSize: 20),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: MaterialButton(
                  color: Colors.lightGreen,
                  minWidth: double.infinity,
                  onPressed: () {
                    checkAnswer(3);
                  },
                  child: Text(
                    "C. ${quizes[currentQuestion].Option_3}",
                    style: TextStyle(fontSize: 20),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: MaterialButton(
                  color: Colors.lightGreen,
                  minWidth: double.infinity,
                  onPressed: () {
                    checkAnswer(4);
                  },
                  child: Text(
                    "D. ${quizes[currentQuestion].Option_4}",
                    style: TextStyle(fontSize: 20),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
