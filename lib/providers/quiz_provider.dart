import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_model.dart';
import '../models/quiz_config_model.dart';
import '../services/api_service.dart';

class QuizProvider with ChangeNotifier {
  final ApiService _apiService;

  static const int questionDurationSeconds = 20;
  static const String _prefKeyAmount = 'quiz_pref_amount';
  static const String _prefKeyDifficulty = 'quiz_pref_difficulty';
  static const String _prefKeyType = 'quiz_pref_type';
  static const String _prefKeyCategoryId = 'quiz_pref_category_id';
  static const String _prefKeyCategoryName = 'quiz_pref_category_name';

  QuizConfigModel _config = const QuizConfigModel(
    amount: 10,
    difficulty: null,
    type: 'multiple',
    categoryId: 9,
    categoryName: 'General Knowledge',
  );

  List<QuestionModel> _questions = [];
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;
  int _score = 0;
  bool _isLoading = false;
  String? _error;
  int _remainingSeconds = questionDurationSeconds;
  int _totalTime = 0;
  bool _quizFinished = false;
  Timer? _timer;

  QuizProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // Getters
  QuizConfigModel get config => _config;
  List<QuestionModel> get questions => List.unmodifiable(_questions);
  int get currentQuestionIndex => _currentQuestionIndex;
  String? get selectedAnswer => _selectedAnswer;
  bool get isAnswered => _isAnswered;
  int get score => _score;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  int get remainingSeconds => _remainingSeconds;
  int get totalTime => _totalTime;
  bool get quizFinished => _quizFinished;
  int get totalQuestions => _questions.length;
  bool get isLastQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex == _questions.length - 1;

  QuestionModel? get currentQuestion {
    if (_questions.isEmpty ||
        _currentQuestionIndex < 0 ||
        _currentQuestionIndex >= _questions.length) {
      return null;
    }
    return _questions[_currentQuestionIndex];
  }

  double get accuracy =>
      totalQuestions > 0 ? (_score / totalQuestions) * 100 : 0.0;

  // SharedPreferences logic
  Future<void> loadSavedConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final amount = prefs.getInt(_prefKeyAmount) ?? 10;
      final difficulty = prefs.getString(_prefKeyDifficulty);
      final type = prefs.getString(_prefKeyType) ?? 'multiple';
      final categoryId = prefs.getInt(_prefKeyCategoryId) ?? 9;
      final categoryName =
          prefs.getString(_prefKeyCategoryName) ?? 'General Knowledge';

      _config = QuizConfigModel(
        amount: amount,
        difficulty: difficulty,
        type: type,
        categoryId: categoryId,
        categoryName: categoryName,
      );
      notifyListeners();
    } catch (_) {
      // Ignore prefs error and keep default config
    }
  }

  Future<void> saveConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefKeyAmount, _config.amount);
      if (_config.difficulty != null && _config.difficulty!.isNotEmpty) {
        await prefs.setString(_prefKeyDifficulty, _config.difficulty!);
      } else {
        await prefs.remove(_prefKeyDifficulty);
      }
      await prefs.setString(_prefKeyType, _config.type);
      await prefs.setInt(_prefKeyCategoryId, _config.categoryId);
      await prefs.setString(_prefKeyCategoryName, _config.categoryName);
    } catch (_) {
      // SharedPreferences fail-safe
    }
  }

  void setSelectedCategory(int categoryId, String categoryName) {
    _config = _config.copyWith(
      categoryId: categoryId,
      categoryName: categoryName,
    );
    notifyListeners();
  }

  void updateConfig({
    int? amount,
    String? difficulty,
    bool clearDifficulty = false,
    String? type,
  }) {
    _config = _config.copyWith(
      amount: amount,
      difficulty: difficulty,
      clearDifficulty: clearDifficulty,
      type: type,
    );
    notifyListeners();
  }

  /// Fetches questions from API with current configuration and starts the timer.
  Future<bool> loadQuestions() async {
    stopTimer();
    _isLoading = true;
    _error = null;
    _questions = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedAnswer = null;
    _isAnswered = false;
    _totalTime = 0;
    _quizFinished = false;
    notifyListeners();

    // Persist configuration
    await saveConfig();

    try {
      final fetchedQuestions = await _apiService.fetchQuestions(
        amount: _config.amount,
        categoryId: _config.categoryId,
        difficulty: _config.difficulty,
        type: _config.type,
      );

      _questions = fetchedQuestions;
      _isLoading = false;
      _error = null;
      notifyListeners();

      if (_questions.isNotEmpty) {
        startTimer();
      }
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void selectAnswer(String answer) {
    if (_isAnswered || _quizFinished) return;

    stopTimer();
    _isAnswered = true;
    _selectedAnswer = answer;

    // Calculate time spent on this question
    final timeSpent = questionDurationSeconds - _remainingSeconds;
    _totalTime += timeSpent > 0 ? timeSpent : 1;

    final question = currentQuestion;
    if (question != null && answer == question.correctAnswer) {
      _score++;
    }
    notifyListeners();
  }

  void handleTimeout() {
    if (_isAnswered || _quizFinished) return;

    stopTimer();
    _isAnswered = true;
    _selectedAnswer = null; // Unanswered
    _totalTime += questionDurationSeconds;
    notifyListeners();
  }

  void nextQuestion() {
    if (_quizFinished) return;

    stopTimer();
    if (_currentQuestionIndex + 1 < _questions.length) {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      _isAnswered = false;
      startTimer();
      notifyListeners();
    } else {
      finishQuiz();
    }
  }

  void startTimer() {
    stopTimer();
    _remainingSeconds = questionDurationSeconds;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _remainingSeconds = 0;
        handleTimeout();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void finishQuiz() {
    stopTimer();
    _quizFinished = true;
    notifyListeners();
  }

  void resetQuiz({bool keepConfig = true}) {
    stopTimer();
    _currentQuestionIndex = 0;
    _selectedAnswer = null;
    _isAnswered = false;
    _score = 0;
    _totalTime = 0;
    _quizFinished = false;
    _error = null;
    _isLoading = false;
    if (!keepConfig) {
      _config = const QuizConfigModel(
        amount: 10,
        difficulty: null,
        type: 'multiple',
        categoryId: 9,
        categoryName: 'General Knowledge',
      );
    }
    notifyListeners();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}
