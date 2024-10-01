import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/controllers/cart_controller.dart';
import 'package:food_delivery_flutter/controllers/popular_product_controller.dart';
import 'package:food_delivery_flutter/controllers/recommended_product_controller.dart';
import 'package:food_delivery_flutter/controllers/user_controller.dart';
import 'package:food_delivery_flutter/data/repository/report_repo.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:food_delivery_flutter/utils/colors.dart';

import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/widgets/app_icon.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:food_delivery_flutter/widgets/expandable_text.dart';
import 'package:food_delivery_flutter/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:food_delivery_flutter/controllers/report_controller.dart';
import 'package:http/http.dart' as http;

class RecommendedFoodDetails extends StatefulWidget {
  final int pageId;
  final String prevPage;

  const RecommendedFoodDetails(
      {Key? key, required this.pageId, required this.prevPage})
      : super(key: key);

  @override
  State<RecommendedFoodDetails> createState() => _RecommendedFoodDetailsState();
}

class _RecommendedFoodDetailsState extends State<RecommendedFoodDetails> {
  String? autoEntrepreneurNumber = ''; // Store auto_entrepreneur_number
  String? nameOfVendeur = '';

  @override
  void initState() {
    super.initState();
    fetchFoodDetails(); // Fetch the data when the widget is initialized
  }

Future<void> fetchFoodDetails() async {
  final url = Uri.parse('${AppConstants.BASE_URL}/api/v1/products/popular') ;
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final products = data['products'];

    // Ensure products is not null and has items
    if (products != null && products.isNotEmpty) {
      setState(() {
        // Check if 'user' is not null before accessing 'f_name'
        if (products[0]['user'] != null) {
          nameOfVendeur = products[0]['user']['f_name'];
          print('Fetched nameOfVendeur: $nameOfVendeur'); // Debugging line
        } else {
          print("User info is missing in the product data.");
        }
      });
    } else {
      print("No products found or products is null.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No products found')),
      );
    }
  } else {
    throw Exception('Failed to load food details');
  }
}


  @override
  Widget build(BuildContext context) {
    var product = Get.find<RecommendedProductController>()
        .recommendedProductList[widget.pageId];
    Get.find<PopularProductController>()
        .initProduct(product, Get.find<CartController>());

     MealController mealController = Get.find<MealController>();
       Get.lazyPut(() => MealController(mealsRepository: Get.find()));

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.yellowColor,
            automaticallyImplyLeading: false,
            toolbarHeight: Dimensions.height80,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.prevPage == "initial") {
                      Get.toNamed(RouteHelper.getInitial());
                    } else if (widget.prevPage == "cartpage") {
                      Get.toNamed(RouteHelper.getCartPage());
                    }
                  },
                  child: AppIcon(icon: Icons.clear),
                ),
                GetBuilder<PopularProductController>(
                  builder: (controller) {
                    return GestureDetector(
                      onTap: () {
                        controller.totalItems >= 1
                            ? Get.toNamed(RouteHelper.getCartPage())
                            : controller.EmptyCart();
                      },
                      child: Stack(
                        children: [
                          AppIcon(
                            icon: Icons.shopping_cart_outlined,
                          ),
                          if (controller.totalItems >= 1)
                            Positioned(
                              right: Dimensions.width1 * 0,
                              top: Dimensions.height1 * 0,
                              child: AppIcon(
                                icon: Icons.circle,
                                size: Dimensions.height1 * 20,
                                iconColor: Colors.transparent,
                                backgroundColor: AppColors.mainColor,
                              ),
                            ),
                          if (controller.totalItems >= 1)
                            Positioned(
                              right: Dimensions.width1 * 7,
                              top: Dimensions.height1 * 3,
                              child: BigText(
                                text: controller.totalItems.toString(),
                                size: Dimensions.font1 * 12,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(Dimensions.height20),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: Dimensions.height5,
                  bottom: Dimensions.height10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (nameOfVendeur != null)
                      SmallText(
                        text: "Chef Name: $nameOfVendeur",
                        size: Dimensions.font20,
                        color: Color.fromARGB(255, 128, 7, 168),
                      ),
                    SizedBox(height: Dimensions.height10),
                    Center(
                      child: BigText(
                        text: "${product.name!}",
                        size: Dimensions.font26,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20),
                    topRight: Radius.circular(Dimensions.radius20),
                  ),
                  color: Colors.white,
                ),
              ),
            ),
            expandedHeight: Dimensions.height265,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                AppConstants.IMAGE_UPLOADS_URL + product.img!,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: Dimensions.width20, right: Dimensions.width20),
                  child: ExpandableTextWidget(
                    text: "${product.description!}",
                  ),
                ),
                SizedBox(height: Dimensions.height50),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(
        builder: (controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: Dimensions.width20 * 2.5,
                  right: Dimensions.width20 * 2.1,
                  top: Dimensions.height10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.setQuantity(false);
                      },
                      child: AppIcon(
                        iconSize: Dimensions.iconSize24,
                        icon: Icons.remove,
                        backgroundColor: AppColors.mainColor,
                        iconColor: Colors.white,
                      ),
                    ),
                    BigText(
                      text: " ${product.price!}DH X${controller.inCartItems}",
                      color: AppColors.mainBlackColor,
                      size: Dimensions.font26,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.setQuantity(true);
                      },
                      child: AppIcon(
                        iconSize: Dimensions.iconSize24,
                        icon: Icons.add,
                        backgroundColor: AppColors.mainColor,
                        iconColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.addItem(product);
                },
                child: Container(
                  height: Dimensions.bottomHeightBar * 0.78,
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    top: Dimensions.height20,
                    bottom: Dimensions.height20,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius20 * 2),
                      topRight: Radius.circular(Dimensions.radius20 * 2),
                    ),
                    color: AppColors.buttonBackgroundColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: Dimensions.height15,
                          bottom: Dimensions.height15,
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: Dimensions.height15,
                          bottom: Dimensions.height15,
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: AppColors.mainColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BigText(
                              text: "${product.price!} Dh | Add to cart",
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: GetBuilder<UserController>(builder: (controller) {
        return controller.userInfoModel.id > 0
            ? FloatingActionButton(
                onPressed: () async {
                  // Call reportMeal method from MealController
                  await mealController.reportMeal(
                    product.id,
                    controller.userInfoModel.id,
                    'Reason for reporting',
                  );
                },
                child: Icon(Icons.report_problem),
                backgroundColor: Colors.red,
              )
            : Container(); // Empty widget if user ID is not valid
      }),
    );
  }
}
