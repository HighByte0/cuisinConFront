
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:food_delivery_flutter/base/common_text_button.dart';
import 'package:food_delivery_flutter/base/no_data_page.dart';
import 'package:food_delivery_flutter/base/show_custom_mesage.dart';
import 'package:food_delivery_flutter/controllers/auth_controller.dart';
import 'package:food_delivery_flutter/controllers/cart_controller.dart';
import 'package:food_delivery_flutter/controllers/location_controller.dart';
import 'package:food_delivery_flutter/controllers/order_controller.dart';
import 'package:food_delivery_flutter/controllers/popular_product_controller.dart';
import 'package:food_delivery_flutter/controllers/recommended_product_controller.dart';
import 'package:food_delivery_flutter/controllers/user_controller.dart';
import 'package:food_delivery_flutter/models/place_order_model.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/utils/payment_option_button.dart';
import 'package:food_delivery_flutter/utils/styles.dart';
import 'package:food_delivery_flutter/widgets/app_icon.dart';
import 'package:food_delivery_flutter/widgets/app_text_field.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:food_delivery_flutter/widgets/small_text.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;
import 'package:awesome_notifications/awesome_notifications.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _notesController=TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: Dimensions.height60,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getInitial());
                  },
                  child: AppIcon(
                    icon: Icons.arrow_back_ios,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: Dimensions.iconSize24,
                  ),
                ),
                SizedBox(width: Dimensions.width100),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getInitial());
                  },
                  child: AppIcon(
                    icon: Icons.home_outlined,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: Dimensions.iconSize24,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getInitial());
                  },
                  child: AppIcon(
                    icon: Icons.shopping_cart,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: Dimensions.iconSize24,
                  ),
                ),
              ],
            ),
          ),
          GetBuilder<CartController>(
            builder: (cartController) {
              var _cartList = cartController.getItems;

              return cartController.getItems.length>0?Positioned(
                top: Dimensions.height100,
                right: Dimensions.width20,
                left: Dimensions.width20,
                bottom: 0,
                child: Container(
                  margin: EdgeInsets.only(
                    top: Dimensions.height10,
                  ),
                  //color: Colors.redAccent,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        itemCount: _cartList.length,
                        itemBuilder: (_, index) {
                          return Container(
                            height: Dimensions.height100,
                            width: double.maxFinite,
                            // color: AppColors.mainColor,
                            margin: EdgeInsets.only(
                              bottom: Dimensions.height10,
                            ),
                            child: Row(
                              children: [
                                // Food Picture
                                GestureDetector(
                                  onTap: () {
                                    var _popularIndex =
                                        Get.find<PopularProductController>()
                                            .popularProductList
                                            .indexOf(_cartList[index].product!);

                                    if (_popularIndex >= 0) {
                                      // product is from Popular Product List
                                      Get.toNamed(
                                          RouteHelper.getPopularFoodDetail(
                                              _popularIndex, "cartpage"));
                                    } else {
                                      // product is from Recommended Product List
                                      var _recommendedIndex = Get.find<
                                              RecommendedProductController>()
                                          .recommendedProductList
                                          .indexOf(_cartList[index].product!);
                                   if(_recommendedIndex<0){
                                    Get.snackbar(
                                                  "History Product",
                                                  "You can't order from history  ",
                                                  backgroundColor: AppColors.mainColor,
                                                  colorText: Colors.white,
                                                );

                                   }else{
                                       Get.toNamed(
                                          RouteHelper.getRecommendedFoodDetail(
                                              _recommendedIndex, "cartpage"));
                                   }
                                    }
                                  },
                                  child: Container(
                                    height: Dimensions.height100,
                                    width: Dimensions.width100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius20),
                                      color: AppColors.mainBlackColor,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            AppConstants.IMAGE_UPLOADS_URL +
                                                _cartList[index].img!),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Dimensions.width10),
                                /** All Component besides Food Picture **/
                                // Using Expanded to maximize horizontally because the parent is Row
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        BigText(
                                          text: _cartList[index].name!,
                                          color: Colors.black54,
                                        ),
                                        SmallText(
                                          text: "Spicy",
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            BigText(
                                                text:
                                                    "\$${_cartList[index].price}",
                                                color: Colors.red),
                                            Container(
                                              padding: EdgeInsets.only(
                                                top: Dimensions.height15,
                                                bottom: Dimensions.height15,
                                                left: Dimensions.width20,
                                                right: Dimensions.width20,
                                              ),
                                              // height: Dimensions.height1 * 200,
                                              // width: Dimensions.width1 * 120,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radius20),
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      cartController.addItem(
                                                          _cartList[index]
                                                              .product!,
                                                          -1);
                                                    },
                                                    child: Icon(Icons.remove,
                                                        color: AppColors
                                                            .signColor),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          Dimensions.width10),
                                                  BigText(
                                                    text: _cartList[index]
                                                        .quantity
                                                        .toString(),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          Dimensions.width10),
                                                  GestureDetector(
                                                    onTap: () {
                                                      cartController.addItem(
                                                          _cartList[index]
                                                              .product!,
                                                          1);
                                                    },
                                                    child: Icon(Icons.add,
                                                        color: AppColors
                                                            .signColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ):const NoData(text: "your cart is empty",imgPath: "assets/image/empty_cart.png",);
            },
            
          )
        ],
      ),
      bottomNavigationBar:GetBuilder<OrderController>(builder: (orderController){
        _notesController.text=orderController.note;
        return  GetBuilder<CartController>(builder: (cartController) {
        return Container(
          height: Dimensions.bottomHeightBar +60,
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
          child: cartController.getItems.length>0?Column(
            children: [
                            InkWell(
                  onTap: () => showModalBottomSheet(
  backgroundColor: Colors.transparent,
  context: context,
  builder: (_) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Use min to fit content
      children: [
        Container(
          padding: EdgeInsets.all(Dimensions.width20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radius20),
              topRight: Radius.circular(Dimensions.radius20),
            ),
          ),
          child: Column(
            children: [
              PaymentOptionButton(
                iconData: Icons.attach_money,
                title: "Cash on Delivery",
                subtitle: "Vous payez après avoir reçu la livraison.",
                index: 0,
              ),
              SizedBox(height: Dimensions.height20), // Add spacing between buttons
              PaymentOptionButton(
                iconData: Icons.credit_card,
                title: "Credit Card",
                subtitle: "Payez en toute commodité à la livraison.",
                index: 1,
              ),
              SizedBox(height: Dimensions.height20), // Add spacing before notes
              
              SizedBox(height: Dimensions.height10), // Add spacing before the text field
              Text("add a notes on your order ",style: robotoMedium,),
                              AppTextFiled(textEditingController:_notesController , hintText: "Exemple : Merci d'ajouter la sauce algérienne", icon: Icons.note)
            
            ],
          ),
        ),
      ],
    );
  },
).whenComplete(() =>orderController.setFoodNotw(_notesController.text.trim())),

                  child: SizedBox(
                  width: double.maxFinite,
                  child: CommonTextButton(text: "payment "),
                  ),
                  ),

             SizedBox(height: Dimensions.height10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Minus, Plus and Counting of Food
                  Container(
                    padding: EdgeInsets.only(
                      top: Dimensions.height15,
                      bottom: Dimensions.height15,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                    ),
                    // height: Dimensions.height1 * 200,
                    // width: Dimensions.width1 * 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: Dimensions.width10),
                        BigText(
                            text:   cartController.totalAmount.toString() +"DH "),
                        SizedBox(width: Dimensions.width10),
                       ],
                      ),
                    ),
              
                   // Check Out Button
                      GestureDetector(
      onTap: () async {
        final authController = Get.find<AuthController>();
        final locationController = Get.find<LocationController>();
        final cartController = Get.find<CartController>();
        final userController = Get.find<UserController>();
        final orderController = Get.find<OrderController>();

        if (authController.hasLogedIn()) {
          if (locationController.addressList.isEmpty) {
            Get.toNamed(RouteHelper.getAddressPage());
          } else {
            var location = locationController.getUserAddress();
            var cart = cartController.getItems;
            var user = userController.userInfoModel;

            PlaceOrderBody placeOrderBody = PlaceOrderBody(
              cart: cart,
              orderAmount: 100.0,
              orderNote: orderController.note,
              address: location.address,
              latitude: location.lat,
              longitude: location.lon,
              contactPersonName: user.name,
              contactPersonNumber: user.phone,
              distance: 200,
              scheduleAt: "2PM",
              paymentType: orderController.paymentIndex == 0 ? 'cash_on_delivery' : 'digital_payment',
            );

            // Place the order
            orderController.placeOrder(
              _callBack,
              placeOrderBody,
            );

            // Add to history
            cartController.addToHistory();

            // Create a notification
            AwesomeNotifications().createNotification(
              
              content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: 'Order Placed',
                body: 'Your order has been successfully placed!',
                notificationLayout: NotificationLayout.Default,
              ),
            );

            // Navigate to a different page if needed
            // Get.offNamed(RouteHelper.getPaymentPage("100001", user.id!));
          }
        } else {
          Get.toNamed(RouteHelper.signInPage);
        }
      },
      child: const CommonTextButton(text: "check out"),
    )
                ],
              ),
            ],
          ):Container()
        );
      });
            },)
         
    );
  }
  void _callBack(bool isSuccess,String message,String orderID){
    if(isSuccess)
    {
     Get.find<CartController>().clear();
       Get.find<CartController>().removeCartSharedPreference();
      Get.find<CartController>().addToHistory();
    //  Get.offNamed(RouteHelper.getPaymentPage(orderID,Get.find<UserController>().userInfoModel.id));
      if(Get.find<OrderController>().paymentIndex==0){
        Get.offNamed(RouteHelper.getOrderSuccessPage("success", orderID));

      }else{
Get.offNamed(RouteHelper.getPaymentPage(orderID,Get.find<UserController>().userInfoModel!.id!));

      }

    }else{
      ShowCustomMesage(message);
    }
  }
}
