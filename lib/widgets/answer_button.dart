import 'package:flutter/material.dart';
import '../app/theme.dart';

class AnswerButton extends StatelessWidget {
  final String answerText;
  final String optionPrefix; // e.g., 'A', 'B', 'C', 'D'
  final bool isAnswered;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.answerText,
    required this.optionPrefix,
    required this.isAnswered,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = const Color(0xFFE2E8F0);
    Color backgroundColor = Colors.white;
    Color textColor = const Color(0xFF1E293B);
    Color prefixBg = const Color(0xFFF1F5F9);
    Color prefixTextColor = const Color(0xFF475569);
    Widget? trailingIcon;

    if (isAnswered) {
      if (isCorrect) {
        borderColor = AppTheme.correctColor;
        backgroundColor = AppTheme.correctBackground;
        textColor = AppTheme.correctColor;
        prefixBg = AppTheme.correctColor;
        prefixTextColor = Colors.white;
        trailingIcon = const Icon(
          Icons.check_circle_rounded,
          color: AppTheme.correctColor,
          size: 24,
        );
      } else if (isSelected) {
        borderColor = AppTheme.wrongColor;
        backgroundColor = AppTheme.wrongBackground;
        textColor = AppTheme.wrongColor;
        prefixBg = AppTheme.wrongColor;
        prefixTextColor = Colors.white;
        trailingIcon = const Icon(
          Icons.cancel_rounded,
          color: AppTheme.wrongColor,
          size: 24,
        );
      } else {
        // Unselected option after question answered
        borderColor = const Color(0xFFF1F5F9);
        backgroundColor = const Color(0xFFF8FAFC);
        textColor = const Color(0xFF94A3B8);
        prefixBg = const Color(0xFFE2E8F0);
        prefixTextColor = const Color(0xFF94A3B8);
      }
    } else if (isSelected) {
      borderColor = AppTheme.primaryColor;
      backgroundColor = AppTheme.primaryColor.withValues(alpha: 0.08);
      textColor = AppTheme.primaryColor;
      prefixBg = AppTheme.primaryColor;
      prefixTextColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          elevation: isAnswered ? 0 : 1,
          shadowColor: Colors.black.withValues(alpha: 0.04),
          child: InkWell(
            onTap: isAnswered ? null : onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor,
                  width: (isAnswered && (isCorrect || isSelected)) ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: prefixBg,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      optionPrefix,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: prefixTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      answerText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected || (isAnswered && isCorrect)
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: textColor,
                        height: 1.3,
                      ),
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    trailingIcon,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
