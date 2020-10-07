import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class QuestionsAssets {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswer;

  QuestionsAssets({this.question, this.correctAnswer, this.incorrectAnswer});

  factory QuestionsAssets.fromJson(Map<String, dynamic> json) =>
      _$QuestionsAssetsFromJson(json);
}

QuestionsAssets _$QuestionsAssetsFromJson(Map<String, dynamic> json) {
  return QuestionsAssets(
      question: replaceString(json['question']),
      correctAnswer: json['correct_answer'] as String,
      incorrectAnswer: json['incorrect_answers'] as List);
}

String replaceString(str) {
  var s;
  s = str.replaceAll("&shy;", " ");
  var j = s.replaceAll("&quot;", " ");
  return j;
}
