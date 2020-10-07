import 'dart:convert' as convert;
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/api/questions_assets.dart';
import 'package:http/http.dart' as http;

class API with ChangeNotifier {
  List<QuestionsAssets> questions;

  List<QuestionsAssets> get questionAssets {
    return questions;
  }

  API.instance();

  Future<List<QuestionsAssets>> getData() async {
    try {
      var url =
          'https://opentdb.com/api.php?amount=10&category=26&difficulty=easy&type=multiple';

      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonRes = convert.jsonDecode(response.body);
        questions = (jsonRes['results'] as List<dynamic>)
            .map((item) => QuestionsAssets.fromJson(item))
            .toList();

        return questions;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
