class QuizConfigModel {
  final int amount;
  final String? difficulty; // 'easy', 'medium', 'hard' or null for 'any'
  final String type; // 'multiple' or 'boolean'
  final int categoryId;
  final String categoryName;

  const QuizConfigModel({
    this.amount = 10,
    this.difficulty,
    this.type = 'multiple',
    required this.categoryId,
    required this.categoryName,
  });

  QuizConfigModel copyWith({
    int? amount,
    String? difficulty,
    bool clearDifficulty = false,
    String? type,
    int? categoryId,
    String? categoryName,
  }) {
    return QuizConfigModel(
      amount: amount ?? this.amount,
      difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'difficulty': difficulty,
      'type': type,
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }

  factory QuizConfigModel.fromJson(Map<String, dynamic> json) {
    return QuizConfigModel(
      amount: json['amount'] as int? ?? 10,
      difficulty: json['difficulty'] as String?,
      type: json['type'] as String? ?? 'multiple',
      categoryId: json['categoryId'] as int? ?? 9,
      categoryName: json['categoryName'] as String? ?? 'General Knowledge',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizConfigModel &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          difficulty == other.difficulty &&
          type == other.type &&
          categoryId == other.categoryId &&
          categoryName == other.categoryName;

  @override
  int get hashCode =>
      amount.hashCode ^
      difficulty.hashCode ^
      type.hashCode ^
      categoryId.hashCode ^
      categoryName.hashCode;
}
