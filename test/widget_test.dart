import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quizzical/app/app.dart';
import 'package:quizzical/providers/category_provider.dart';
import 'package:quizzical/providers/quiz_provider.dart';

void main() {
  testWidgets('Quizzical app loads WelcomeScreen with title and GET STARTED button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
          ChangeNotifierProvider(create: (_) => QuizProvider()),
        ],
        child: const QuizzicalApp(),
      ),
    );

    // Verify WelcomeScreen elements matching reference design
    expect(find.text('Quizzical'), findsOneWidget);
    expect(find.text('MD.Rayhan'), findsOneWidget);
    expect(find.text('GET STARTED'), findsOneWidget);
  });
}
