import 'package:flutter_complete_guide/api/questions_assets.dart';
import 'package:provider/provider.dart';

import './api/api.dart';

import './size_config.dart';
import 'package:flutter/material.dart';

class QuestionaireScreen extends StatefulWidget {
  @override
  _QuestionaireScreenState createState() => _QuestionaireScreenState();
}

class _QuestionaireScreenState extends State<QuestionaireScreen> {
  int _questionIndex = 0;
  int finalScore = 0;
  bool _loadContent = true;
  bool _isInit = false;
  List<QuestionsAssets> _ass = [];

  var answers = [];

  var questions = [];

  Map<String, List<String>> choices;

  List<String> chosenAnswer = [];

  API _api;

  @override
  void initState() {
    super.initState();
  }

  void myfunc() async {
    _api = Provider.of<API>(context);
    if (_loadContent) {
      if (_api.questionAssets == null) {
        await _api.getData();
      }
      _ass = _api.questionAssets;
      print(_ass[0]);
      // for (int i = 1; i < _ass.length; i++) {
      //   questions.add(_ass[i].question);
      //   answers.add(_ass[i].correctAnswer);
      //   print(_ass[0].incorrectAnswer);
      //   // choices["$i"] = _ass[i].incorrectAnswer;
      //   // choices["$i"].add(_ass[i].correctAnswer);
      //   chosenAnswer.add(null);
      // }
      setState(() {
        _loadContent = false;
      });
    }
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  final PageController controller = PageController(initialPage: 200);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    if (!_isInit) {
      myfunc();
    }
    return !_loadContent
        ? WillPopScope(
            onWillPop: _onBackPressed,
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: height * 0.03,
                  ),
                  // Container(
                  //   height: height * 0.25,
                  //   padding: EdgeInsets.only(left: 50, right: 50, bottom: 50),
                  //   child: Text(
                  //     questions[_questionIndex],
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black,
                  //         fontSize: 17),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(8.0),
                          children: [
                        customButton(context),
                        customButton(context),
                        customButton(context),
                        customButton(context)
                      ])),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {}),
                      FlatButton(
                        onPressed: _previousQuestion,
                        child: Icon(Icons.arrow_back_ios),
                        // color: Colors.blue,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: map<Widget>(questions, (index, q) {
                          return Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _questionIndex == index
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),
                      FlatButton(
                        onPressed: _nextQuestion,
                        child: Icon(Icons.arrow_forward_ios),
                        // color: Colors.blue,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  int _previousQuestion() {
    if (_questionIndex == 0)
      return _questionIndex;
    else
      setState(() {
        return _questionIndex = _questionIndex - 1;
      });
  }

  Future _nextQuestion() {
    if (_questionIndex == questions.length - 1)
      return _questionaireEnd();
    else
      setState(() {
        _questionIndex = _questionIndex + 1;
      });
  }

  Future _questionaireEnd() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sumbit the answers'),
            content: Text('Do you want to submit the answer?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    scoreCalculator();
                  },
                  child: Text('YES')),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('NO')),
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
          );
        });
  }

  void scoreCalculator() {
    var score = 0;
    for (var i = 0; i <= questions.length - 1; i++) {
      if (chosenAnswer[i] == answers[i]) {
        score++;
      }
    }
    setState(() {
      finalScore = score;
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Exit questionnaire?'),
            content: new Text(
                'The answers will not be saved. Do you really want to exit?'),
            actions: <Widget>[
              FlatButton(onPressed: () {}, child: Text('YES')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('NO')),
            ],
          ),
        ) ??
        false;
  }

  Widget customButton(BuildContext context) {
    return FlatButton(onPressed: () {}, child: Text('Hey'));
  }
}
