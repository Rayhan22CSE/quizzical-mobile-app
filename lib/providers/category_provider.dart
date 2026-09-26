import 'package:flutter/foundation.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryProvider with ChangeNotifier {
  final ApiService _apiService;

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoaded = false;

  CategoryProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  List<CategoryModel> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isLoaded => _isLoaded;

  /// Fetches categories from API. Caches result in memory for session.
  Future<void> loadCategories({bool forceRefresh = false}) async {
    // If already loaded and not forcing refresh, do not call API again.
    if (_isLoaded && _categories.isNotEmpty && !forceRefresh) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await _apiService.fetchCategories();
      _categories = fetched;
      _isLoaded = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
