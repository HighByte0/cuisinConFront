

import 'package:food_delivery_flutter/controllers/auth_controller.dart';
import 'package:food_delivery_flutter/controllers/cart_controller.dart';
import 'package:food_delivery_flutter/controllers/location_controller.dart';
import 'package:food_delivery_flutter/controllers/order_controller.dart';
import 'package:food_delivery_flutter/controllers/popular_product_controller.dart';
import 'package:food_delivery_flutter/controllers/recommended_product_controller.dart';
import 'package:food_delivery_flutter/controllers/report_controller.dart';
import 'package:food_delivery_flutter/controllers/user_controller.dart';
import 'package:food_delivery_flutter/data/api/api_client.dart';
import 'package:food_delivery_flutter/data/repository/auth_repo.dart';
import 'package:food_delivery_flutter/data/repository/cart_repo.dart';
import 'package:food_delivery_flutter/data/repository/location_repo.dart';
import 'package:food_delivery_flutter/data/repository/order_repo.dart';
import 'package:food_delivery_flutter/data/repository/popular_product_repo.dart';
import 'package:food_delivery_flutter/data/repository/recommended_product_repo.dart';
import 'package:food_delivery_flutter/data/repository/report_repo.dart';
import 'package:food_delivery_flutter/data/repository/user_repo.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  // Shared Preferences
  Get.lazyPut(() => sharedPreferences);

  // ApiClient
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL,sharedPreferences:Get.find()));
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find(),));






  // Repos
   Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocatonRepo(apiClient: Get.find(),sharedPreferences: Get.find()));
  Get.lazyPut(() => OrderRepo(apiClient: Get.find()));
  Get.lazyPut(() => ReportRepo(apiClient: Get.find()));
    // Controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
  Get.lazyPut(() => RecommendedProductController(recommendedProductRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));
  Get.lazyPut(() => MealController(mealsRepository: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
    
}
