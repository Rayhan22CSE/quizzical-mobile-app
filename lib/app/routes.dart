import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/category_screen.dart';
import '../screens/quiz_config_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/result_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String categories = '/categories';
  static const String quizConfig = '/quiz-config';
  static const String quiz = '/quiz';
  static const String results = '/results';

  static Map<String, WidgetBuilder> get routes => {
        welcome: (context) => const WelcomeScreen(),
        categories: (context) => const CategoryScreen(),
        quizConfig: (context) => const QuizConfigScreen(),
        quiz: (context) => const QuizScreen(),
        results: (context) => const ResultScreen(),
      };
}
