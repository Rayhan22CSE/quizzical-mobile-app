import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/retry_banner.dart';
import '../app/routes.dart';
import '../app/theme.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900
        ? 4
        : screenWidth > 600
            ? 3
            : 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                Text(
                  'MD.Rayhan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    'MR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          if (categoryProvider.isLoading) {
            return const CategorySkeletonGrid();
          }

          if (categoryProvider.hasError) {
            return RetryBanner(
              message: categoryProvider.errorMessage ??
                  'Failed to load trivia categories.',
              onRetry: () {
                categoryProvider.loadCategories(forceRefresh: true);
              },
            );
          }

          final categories = categoryProvider.categories;
          if (categories.isEmpty) {
            return RetryBanner(
              message: 'No categories available at the moment.',
              onRetry: () {
                categoryProvider.loadCategories(forceRefresh: true);
              },
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title matching reference design screenshot
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quizzical',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.titleTextColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'choose a category to focus on:',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Serif',
                        color: Color(0xFF8E9BAE),
                      ),
                    ),
                  ],
                ),
              ),
              // Category Cards Grid matching reference layout exactly
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.88,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryCard(
                      category: category,
                      index: index,
                      onTap: () {
                        final quizProvider =
                            Provider.of<QuizProvider>(context, listen: false);
                        quizProvider.setSelectedCategory(
                            category.id, category.name);
                        Navigator.pushNamed(context, AppRoutes.quizConfig);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
