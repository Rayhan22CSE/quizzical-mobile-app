import 'package:flutter/material.dart';
import '../app/routes.dart';
import '../app/theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      // Top Reference Illustration (Boy thinking with question marks)
                      Image.asset(
                        'assets/images/welcome_hero.png',
                        height: 240,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 36),
                      // App Title matching reference design font style
                      const Text(
                        'Quizzical',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.titleTextColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // User's Name as requested
                      const Text(
                        'MD.Rayhan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.titleTextColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 32),
                      // GET STARTED button matching reference design
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.categories);
                        },
                        child: const Text('GET STARTED'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
