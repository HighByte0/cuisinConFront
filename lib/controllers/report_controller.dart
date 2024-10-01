import 'package:food_delivery_flutter/data/repository/report_repo.dart';
import 'package:food_delivery_flutter/models/report_model.dart';
import 'package:get/get.dart';

class MealController extends GetxController {
  final ReportRepo mealsRepository;

  MealController({required this.mealsRepository});

  // Méthode pour signaler un repas
  Future<void> reportMeal(int mealId,int userId, String reason) async {
    try {
      Report mealReport = Report(mealId: mealId, reason: reason, userId: userId);
      // Appeler la méthode du repository pour signaler le repas
      await mealsRepository.reportMeal(mealReport);
      Get.snackbar('Success', 'The meal has been reported successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to report the meal.');
    }
  }
}
