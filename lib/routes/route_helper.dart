import 'package:food_delivery_flutter/controllers/user_controller.dart';
import 'package:food_delivery_flutter/models/order_model.dart';
import 'package:food_delivery_flutter/pages/address/add_adress_page.dart';
import 'package:food_delivery_flutter/pages/address/pick_add_map.dart';
import 'package:food_delivery_flutter/pages/auth/sign_in_page.dart';
import 'package:food_delivery_flutter/pages/block/block_page.dart';
import 'package:food_delivery_flutter/pages/cart/cart_page.dart';
import 'package:food_delivery_flutter/pages/food/popular_food_detail.dart';
import 'package:food_delivery_flutter/pages/food/recommended_food_details.dart';
import 'package:food_delivery_flutter/pages/home/home_page.dart';
import 'package:food_delivery_flutter/pages/orders/orde_success_page.dart';
import 'package:food_delivery_flutter/pages/splash/splash_page.dart';
import 'package:food_delivery_flutter/payment/payment_page.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = "/";
  static const String popularFoodDetail = "/popular-food-detail";
  static const String recommendedFoodDetail = "/recommended-food-detail";
  static const String cartPage = "/cart-page";
  static const String splashPage = "/splash-page";
  static const String signInPage = "/sign-in";
  static const String addAddress = "/add-address";
  static const String pickAddMap = "/pick-address";
  static const String payment = '/payment';
  static const String orderSuccess = '/order-successful';
  static const String blockPage = '/account-blocked';

  static String getInitial() => initial;
  static String getBlockPage()=> blockPage;
  static String getAddressPage() => addAddress;
  static String getPopularFoodDetail(int pageId, String prevPage) =>
      '$popularFoodDetail?pageId=$pageId&prevPage=$prevPage';
  static String getRecommendedFoodDetail(int pageId, String prevPage) =>
      '$recommendedFoodDetail?pageId=$pageId&prevPage=$prevPage';
  static String getCartPage() => cartPage;
  static String getSplashPage() => splashPage;
  static String getSignInPage() => signInPage;
  static String getPickAddMap() => pickAddMap;
  static String getPaymentPage(String id, int userID) =>'$payment?userID=$userID&id=$id&';
  static String getOrderSuccessPage(String status, String orderID) => '$orderSuccess?orderID=$orderID&status=$status';

  static List<GetPage> routes = [
    
    GetPage(
      name: blockPage,
      page: () => AccountBlockedPage(),
     
    ),

    GetPage(
      name: initial,
      page: () => HomePage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: popularFoodDetail,
      page: () {
        var pageId = Get.parameters['pageId'];
        var prevPage = Get.parameters['prevPage'];

        return PopularFoodDetail(
          pageId: int.parse(pageId!),
          prevPage: prevPage!, 
        );
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signInPage,
      page: () => const SignInPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: recommendedFoodDetail,
      page: () {
        var pageId = Get.parameters['pageId'];
        var prevPage = Get.parameters['prevPage'];

        return RecommendedFoodDetails(
          pageId: int.parse(pageId!),
          prevPage: prevPage!,
        );
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: cartPage,
      page: () => const CartPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(name: addAddress, page: () => AddPage()),
    GetPage(name: splashPage, page: () => const SplashScreen()),
    GetPage(name: pickAddMap, page: () {
      PickAddMap _pickAddress = Get.arguments;
      return _pickAddress;
    }),
    GetPage(
      name: payment,
      page: () {
        final id = Get.parameters['id'];
        final userId = Get.parameters['userID'];

        // Ensure the parameters are not null before parsing
        if (id != null && userId != null) {
          return PaymentScreen(
            orderModel: OrderModel(
              id: 20,
              userId:Get.find<UserController>().userInfoModel.id,
            ),
          );
        } else {
          throw FormatException("Missing parameters for PaymentScreen");
        }
      },
    ),
    GetPage(
      name: orderSuccess,
      page: () {
        // Extract parameters from the route
        final orderId = Get.parameters['orderID'];
        final statusString = Get.parameters['status'];

        // Handle null cases gracefully
        final orderID = orderId != null ? int.tryParse(orderId) ?? 0 : 0;
        final status = statusString?.toLowerCase() == 'success' ? 1 : 0;

        // Return the OrderSuccessPage with the extracted parameters
        return OrderSuccessPage(orderID: orderID, status: status);
      },
    ),
  ];
}
