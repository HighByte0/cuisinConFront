import 'package:food_delivery_flutter/data/api/api_client.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:food_delivery_flutter/models/report_model.dart'; // Ensure this import
import 'dart:convert';

class ReportRepo {
  late ApiClient apiClient;

  // Constructor to initialize ApiClient
  ReportRepo({required this.apiClient});

  // Method to report a meal
  Future<void> reportMeal(Report mealReport) async {
     apiClient.postData(
        AppConstants.REPORT_URI,
        mealReport.toJson(),
      );  
  
  }
}
