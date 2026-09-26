import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/question_model.dart';

class ApiException implements Exception {
  final String message;
  final int? code;

  ApiException(this.message, {this.code});

  @override
  String toString() => message;
}

class ApiService {
  final http.Client client;
  static const Duration timeoutDuration = Duration(seconds: 15);

  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// Fetches trivia categories from OpenTDB API.
  Future<List<CategoryModel>> fetchCategories() async {
    final url = Uri.https('opentdb.com', '/api_category.php');
    try {
      final response = await client.get(url).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> categoriesJson =
            data['trivia_categories'] as List<dynamic>? ?? [];
        return categoriesJson
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
            'Failed to fetch categories. Server returned HTTP ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException(
          'Network connection error. Please check your internet connection and try again.');
    } on TimeoutException {
      throw ApiException(
          'Request timed out. Please check your internet connection.');
    } on FormatException {
      throw ApiException('Invalid data format received from server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Fetches quiz questions from OpenTDB API based on configuration parameters.
  Future<List<QuestionModel>> fetchQuestions({
    required int amount,
    required int categoryId,
    String? difficulty,
    required String type,
  }) async {
    final Map<String, String> queryParams = {
      'amount': amount.toString(),
      'category': categoryId.toString(),
    };

    if (difficulty != null &&
        difficulty.isNotEmpty &&
        difficulty.toLowerCase() != 'any') {
      queryParams['difficulty'] = difficulty.toLowerCase();
    }

    if (type.isNotEmpty) {
      queryParams['type'] = type;
    }

    final url = Uri.https('opentdb.com', '/api.php', queryParams);

    try {
      final response = await client.get(url).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final int responseCode = data['response_code'] as int? ?? -1;

        if (responseCode == 0) {
          final List<dynamic> resultsJson =
              data['results'] as List<dynamic>? ?? [];
          if (resultsJson.isEmpty) {
            throw ApiException(
                'No questions found for the selected options. Try changing category or difficulty.',
                code: responseCode);
          }
          return resultsJson
              .map((json) =>
                  QuestionModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } else if (responseCode == 1) {
          throw ApiException(
              'Not enough questions available for this configuration. Please lower the question count.',
              code: responseCode);
        } else if (responseCode == 2) {
          throw ApiException(
              'Invalid query parameters sent to OpenTDB server.',
              code: responseCode);
        } else if (responseCode == 5) {
          throw ApiException(
              'Rate limit exceeded. Please wait a moment and try again.',
              code: responseCode);
        } else {
          throw ApiException(
              'OpenTDB API error (Code $responseCode). Please try again later.',
              code: responseCode);
        }
      } else {
        throw ApiException(
            'Failed to fetch questions. Server returned HTTP ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException(
          'Network connection error. Please check your internet connection.');
    } on TimeoutException {
      throw ApiException(
          'Connection timed out. Please check your network speed.');
    } on FormatException {
      throw ApiException('Failed to parse question response format.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch questions: ${e.toString()}');
    }
  }
}
