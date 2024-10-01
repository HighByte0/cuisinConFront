import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/controllers/cart_controller.dart';
import 'package:food_delivery_flutter/controllers/popular_product_controller.dart';
import 'package:food_delivery_flutter/controllers/recommended_product_controller.dart';

import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:get/get.dart';
import 'helper/dependencies.dart' as dep;
import 'package:awesome_notifications/awesome_notifications.dart';
Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // make sure all dependencies are loaded completely
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().initialize(
  'resource://drawable/notif',
  [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic tests',
      defaultColor: Color(0xFF9D50DD),
      ledColor: Colors.white,
      importance: NotificationImportance.High,

    )
  ],
);

    Get.find<CartController>().getCartData();

    return GetBuilder<PopularProductController>(builder: (_) {
      return GetBuilder<RecommendedProductController>(builder: (_) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
         initialRoute: RouteHelper.getSplashPage(),
         getPages: RouteHelper.routes,
        //  home: SignInPage(),
        );
      });
    });

    // return GetBuilder<PopularProductController>(builder: (_) => {
    //   return GetBuilder<RecommendedProductController>(builder: (_) => {
    //     return GetMaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   initialRoute: RouteHelper.getSplashPage(),
    //   getPages: RouteHelper.routes,
    // );

    // });

    // });
  }
}
