import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/answer_button.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/retry_banner.dart';
import '../app/routes.dart';
import '../app/theme.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  Future<bool> _onWillPop(BuildContext context) async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Quit Quiz?'),
        content: const Text(
          'Are you sure you want to exit? Your current quiz progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.wrongColor,
              minimumSize: const Size(100, 42),
            ),
            onPressed: () {
              quizProvider.stopTimer();
              Navigator.of(context).pop(true);
            },
            child: const Text('Quit'),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          // If quiz finished, navigate to results screen
          if (quizProvider.quizFinished) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, AppRoutes.results);
            });
          }

          if (quizProvider.isLoading) {
            return Scaffold(
              appBar: AppBar(title: const Text('Loading Quiz...')),
              body: const QuizSkeletonLoader(),
            );
          }

          if (quizProvider.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Quiz Error')),
              body: RetryBanner(
                message: quizProvider.error ?? 'Failed to load questions.',
                onRetry: () {
                  quizProvider.loadQuestions();
                },
              ),
            );
          }

          final question = quizProvider.currentQuestion;
          if (question == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Quizzical')),
              body: RetryBanner(
                message: 'No questions available.',
                onRetry: () {
                  quizProvider.loadQuestions();
                },
              ),
            );
          }

          final currentIndex = quizProvider.currentQuestionIndex;
          final total = quizProvider.totalQuestions;
          final progress = total > 0 ? (currentIndex + 1) / total : 0.0;
          final remainingSec = quizProvider.remainingSeconds;
          final isAnswered = quizProvider.isAnswered;
          final selectedAnswer = quizProvider.selectedAnswer;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('MD.Rayhan (${currentIndex + 1}/$total)'),
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: remainingSec <= 5
                            ? AppTheme.wrongBackground
                            : AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: remainingSec <= 5
                              ? AppTheme.wrongColor
                              : AppTheme.primaryColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 18,
                            color: remainingSec <= 5
                                ? AppTheme.wrongColor
                                : AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${remainingSec}s',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: remainingSec <= 5
                                  ? AppTheme.wrongColor
                                  : AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(6),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  minHeight: 6,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Meta row: Category pill & Difficulty badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            question.category.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            question.difficulty.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Question Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Answer Options Header
                    const Text(
                      'Choose Answer',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Answer Buttons List
                    ...List.generate(question.allAnswers.length, (index) {
                      final answerOption = question.allAnswers[index];
                      final optionPrefix = String.fromCharCode(65 + index); // A, B, C, D
                      final isSelected = selectedAnswer == answerOption;
                      final isCorrect = answerOption == question.correctAnswer;

                      return AnswerButton(
                        answerText: answerOption,
                        optionPrefix: optionPrefix,
                        isAnswered: isAnswered,
                        isSelected: isSelected,
                        isCorrect: isCorrect,
                        onTap: () {
                          quizProvider.selectAnswer(answerOption);
                        },
                      );
                    }),
                    const SizedBox(height: 16),

                    // Feedback Banner & Next Button
                    if (isAnswered) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selectedAnswer == question.correctAnswer
                              ? AppTheme.correctBackground
                              : AppTheme.wrongBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selectedAnswer == question.correctAnswer
                                ? AppTheme.correctColor
                                : AppTheme.wrongColor,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selectedAnswer == question.correctAnswer
                                  ? Icons.check_circle_rounded
                                  : Icons.info_rounded,
                              color: selectedAnswer == question.correctAnswer
                                  ? AppTheme.correctColor
                                  : AppTheme.wrongColor,
                              size: 26,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                selectedAnswer == null
                                    ? 'Time\'s up! The correct answer is: ${question.correctAnswer}'
                                    : selectedAnswer == question.correctAnswer
                                        ? 'Correct answer! Great job! 🎉'
                                        : 'Incorrect! The correct answer is: ${question.correctAnswer}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: selectedAnswer == question.correctAnswer
                                      ? AppTheme.correctColor
                                      : AppTheme.wrongColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          quizProvider.nextQuestion();
                        },
                        icon: Icon(
                          quizProvider.isLastQuestion
                              ? Icons.workspace_premium_rounded
                              : Icons.arrow_forward_rounded,
                        ),
                        label: Text(
                          quizProvider.isLastQuestion
                              ? 'See Results'
                              : 'Next Question',
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
