import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../app/routes.dart';
import '../app/theme.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MD.Rayhan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          final score = quizProvider.score;
          final total = quizProvider.totalQuestions;
          final accuracy = quizProvider.accuracy;
          final totalTime = quizProvider.totalTime;

          final accuracyPercentage = accuracy.round();

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  // Reference Illustration: 3D Party Popper Confetti Horn
                  Image.asset(
                    'assets/images/result_hero.png',
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),

                  // Title: "Congratulation" matching reference design exact text
                  const Text(
                    'Congratulation',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.titleTextColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Percentage Pill Card matching reference design (80%)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF80ED99),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF80ED99).withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$accuracyPercentage%',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.titleTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Subtitle message matching reference design
                  const Text(
                    'You\'ve got a great foundation. Ready to try a different category?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.titleTextColor,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Stats Row
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Score',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$score / $total',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: const Color(0xFFE2E8F0),
                        ),
                        Column(
                          children: [
                            const Text(
                              'Time Spent',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${totalTime}s',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFB8500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Primary CTA: PLAY AGAIN matching reference design
                  ElevatedButton(
                    onPressed: () async {
                      quizProvider.resetQuiz(keepConfig: true);
                      final success = await quizProvider.loadQuestions();
                      if (context.mounted) {
                        if (success) {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.quiz);
                        } else {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.quizConfig);
                        }
                      }
                    },
                    child: const Text('PLAY AGAIN'),
                  ),
                  const SizedBox(height: 14),

                  // Secondary CTA: Choose Another Category
                  OutlinedButton(
                    onPressed: () {
                      quizProvider.resetQuiz(keepConfig: false);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.categories,
                        (route) => route.isFirst,
                      );
                    },
                    child: const Text('CHOOSE ANOTHER CATEGORY'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
