class Report {
  final int mealId;
  final int userId;
  final String reason;

  Report({
    required this.mealId,
    required this.reason,
    required this.userId
  });

  // Convertir l'objet MealReport en JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id':userId,
      'prod_id': mealId,
      'reason': reason,
    };
  }
}
