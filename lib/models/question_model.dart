import 'dart:math';
import '../utils/html_utils.dart';

class QuestionModel {
  final String type;
  final String difficulty;
  final String category;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> allAnswers;

  QuestionModel({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.allAnswers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json, {Random? random}) {
    final type = json['type'] as String? ?? 'multiple';
    final difficulty = json['difficulty'] as String? ?? 'medium';
    final category = HtmlUtils.unescape(json['category'] as String? ?? '');
    final rawQuestion = json['question'] as String? ?? '';
    final rawCorrectAnswer = json['correct_answer'] as String? ?? '';
    final rawIncorrectAnswers = (json['incorrect_answers'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final question = HtmlUtils.unescape(rawQuestion);
    final correctAnswer = HtmlUtils.unescape(rawCorrectAnswer);
    final incorrectAnswers =
        rawIncorrectAnswers.map((e) => HtmlUtils.unescape(e)).toList();

    List<String> allAnswers;
    if (type == 'boolean') {
      // For boolean, ensure True and False options exist
      allAnswers = const ['True', 'False'];
    } else {
      allAnswers = [correctAnswer, ...incorrectAnswers];
      allAnswers.shuffle(random ?? Random());
    }

    return QuestionModel(
      type: type,
      difficulty: difficulty,
      category: category,
      question: question,
      correctAnswer: correctAnswer,
      incorrectAnswers: incorrectAnswers,
      allAnswers: allAnswers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'difficulty': difficulty,
      'category': category,
      'question': question,
      'correct_answer': correctAnswer,
      'incorrect_answers': incorrectAnswers,
      'all_answers': allAnswers,
    };
  }
}
