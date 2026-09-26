import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../app/routes.dart';
import '../app/theme.dart';

class QuizConfigScreen extends StatefulWidget {
  const QuizConfigScreen({super.key});

  @override
  State<QuizConfigScreen> createState() => _QuizConfigScreenState();
}

class _QuizConfigScreenState extends State<QuizConfigScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: false).loadSavedConfig();
    });
  }

  Future<void> _startQuiz() async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final success = await quizProvider.loadQuestions();
    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(context, AppRoutes.quiz);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            quizProvider.error ?? 'Failed to start quiz. Please try again.',
          ),
          backgroundColor: AppTheme.wrongColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          final config = quizProvider.config;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Reference Illustration (Hand adjusting toggle switches with gear)
                  Image.asset(
                    'assets/images/config_hero.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),

                  // Title: "Quizzical"
                  const Text(
                    'Quizzical',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.titleTextColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle: "Configuration"
                  const Text(
                    'Configuration',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Selected Category Name
                  Text(
                    config.categoryName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.titleTextColor,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 1. Amount Configuration matching reference design slider
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Number of Questions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.titleTextColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Select 1–50',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          Text(
                            '${config.amount}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00A8FF),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: config.amount.toDouble(),
                        min: 1,
                        max: 50,
                        divisions: 49,
                        label: '${config.amount}',
                        onChanged: quizProvider.isLoading
                            ? null
                            : (double value) {
                                quizProvider.updateConfig(amount: value.toInt());
                              },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. Difficulty Level Dropdown matching reference design
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Difficulty Level',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.titleTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String?>(
                        initialValue: config.difficulty,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        items: const [
                          DropdownMenuItem<String?>(
                            value: null,
                            child: Text('Any Difficulty'),
                          ),
                          DropdownMenuItem<String?>(
                            value: 'easy',
                            child: Text('Easy'),
                          ),
                          DropdownMenuItem<String?>(
                            value: 'medium',
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem<String?>(
                            value: 'hard',
                            child: Text('Hard'),
                          ),
                        ],
                        onChanged: quizProvider.isLoading
                            ? null
                            : (String? newValue) {
                                quizProvider.updateConfig(
                                  difficulty: newValue,
                                  clearDifficulty: newValue == null,
                                );
                              },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 3. Question Type Dropdown matching reference design
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Question Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.titleTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: config.type,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'multiple',
                            child: Text('Multiple Choice'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'boolean',
                            child: Text('True / False'),
                          ),
                        ],
                        onChanged: quizProvider.isLoading
                            ? null
                            : (String? newValue) {
                                if (newValue != null) {
                                  quizProvider.updateConfig(type: newValue);
                                }
                              },
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // START Button matching reference design
                  ElevatedButton(
                    onPressed: quizProvider.isLoading ? null : _startQuiz,
                    child: quizProvider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text('START'),
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
