import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/controllers/cart_controller.dart';
import 'package:food_delivery_flutter/controllers/popular_product_controller.dart';
import 'package:food_delivery_flutter/controllers/report_controller.dart';
import 'package:food_delivery_flutter/controllers/user_controller.dart';
import 'package:food_delivery_flutter/data/repository/report_repo.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/widgets/app_column.dart';
import 'package:food_delivery_flutter/widgets/app_icon.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:food_delivery_flutter/widgets/expandable_text.dart';
import 'package:food_delivery_flutter/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PopularFoodDetail extends StatefulWidget {
  final int pageId;
  final String prevPage;

  PopularFoodDetail({Key? key, required this.pageId, required this.prevPage})
      : super(key: key);

  @override
  _PopularFoodDetailState createState() => _PopularFoodDetailState();
}

class _PopularFoodDetailState extends State<PopularFoodDetail> {
  String? autoEntrepreneurNumber;
  String? nameOfVendeur;



  Future<void> fetchFoodDetails() async {
    try {
      final url = Uri.parse('${AppConstants.BASE_URL}/api/v1/products/recommended');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = data['products'];

        if (products.isNotEmpty) {
          setState(() {
            autoEntrepreneurNumber = products[0]['user']['auto_entrepreneur_number'];
            nameOfVendeur = products[0]['user']['f_name'];
          });
        }
      } else {
        throw Exception('Failed to load food details');
      }
    } catch (e) {
      // Show user-friendly message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load food details')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFoodDetails();
  }

  @override
  Widget build(BuildContext context) {
    var product = Get.find<PopularProductController>().popularProductList[widget.pageId];
    Get.find<PopularProductController>().initProduct(product, Get.find<CartController>());
      final  mealController = Get.find<MealController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: Dimensions.popularFoodImgSize * 0.80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    AppConstants.IMAGE_UPLOADS_URL + product.img!,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: Dimensions.height45,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
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
                  child: AppIcon(icon: Icons.arrow_back_ios),
                ),
                GetBuilder<PopularProductController>(builder: (controller) {
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
                }),
              ],
            ),
          ),
          Positioned(
            top: Dimensions.popularFoodImgSize - 2.9 * Dimensions.height30,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: Dimensions.width20,
                right: Dimensions.width20,
                top: Dimensions.height20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.height20),
                  topRight: Radius.circular(Dimensions.height20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText(
                    text: "RC|CIE|NIF: $autoEntrepreneurNumber",
                    size: Dimensions.font20,
                    color: Color.fromARGB(255, 128, 7, 168),
                  ),
                  SmallText(
                    text: "Chef Name: $nameOfVendeur",
                    size: Dimensions.font20,
                    color: Color.fromARGB(255, 128, 7, 168),
                  ),
                  AppColumn(
                    foodTitle: product.name!,
                  ),
                  SizedBox(height: Dimensions.height20),
                  BigText(text: "Introduce", size: Dimensions.font20),
                  SizedBox(height: Dimensions.height20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ExpandableTextWidget(text: product.description!),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder: (popularProduct) {
        return Container(
          height: Dimensions.bottomHeightBar * 0.78,
          width: double.infinity,
          padding: EdgeInsets.all(Dimensions.width20),
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
                padding: EdgeInsets.all(Dimensions.width20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        popularProduct.setQuantity(false);
                      },
                      child: Icon(Icons.remove, color: AppColors.signColor),
                    ),
                    SizedBox(width: Dimensions.width10),
                    BigText(text: popularProduct.inCartItems.toString()),
                    SizedBox(width: Dimensions.width10),
                    GestureDetector(
                      onTap: () {
                        popularProduct.setQuantity(true);
                      },
                      child: Icon(Icons.add, color: AppColors.signColor),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  popularProduct.addItem(product);
                },
                child: Container(
                  padding: EdgeInsets.all(Dimensions.width20/3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color: AppColors.mainColor,
                  ),
                  child: BigText(
                    text: "${product.price!}DH | Add to Cart",
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }),

        floatingActionButton: GetBuilder<UserController>(builder: (controller) {
  return controller.userInfoModel.id > 0
      ? FloatingActionButton(
          onPressed: () async {
            // Show confirmation dialog
            bool confirm = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Report'),
                  content: Text('Are you sure you want to report this meal?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // User did not confirm
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // User confirmed
                      },
                      child: Text('Confirm'),
                    ),
                  ],
                );
              },
            ) ?? false;

            if (confirm) {
              // Call reportMeal method from MealController if user confirmed
              await mealController.reportMeal(
                product.id, 
                controller.userInfoModel.id, 
                'Reason for reporting',
              );
            }
          },
          child: Icon(Icons.report_problem),
          backgroundColor: Colors.red,
        )
      : Container(); // Empty widget if user ID is not valid
}),

    );
  }
}
