import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/base/custom_app_bar.dart';
import 'package:food_delivery_flutter/base/custom_loder.dart';
import 'package:food_delivery_flutter/controllers/auth_controller.dart';
import 'package:food_delivery_flutter/controllers/location_controller.dart';
import 'package:food_delivery_flutter/controllers/user_controller.dart';
import 'package:food_delivery_flutter/pages/account/Account_widget.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/widgets/app_icon.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final LocationController locationController = Get.find<LocationController>();
    bool _userLoggedIn = Get.find<AuthController>().hasLogedIn();

    if (_userLoggedIn) {
      Get.find<UserController>().getuserinfo();
    }

    return Scaffold(
      appBar: CustomAppBar(title: "Profile"),
      body: GetBuilder<LocationController>(builder: (locationController) {
        return GetBuilder<UserController>(builder: (controller) {
          return _userLoggedIn
              ? (controller.isLoaded
                  ? Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(top: Dimensions.height10 * 2),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                BigText(text: "Hello"),
                                AppIcon(
                                  icon: Icons.person,
                                  backgroundColor: AppColors.mainColor,
                                  iconColor: Colors.white,
                                  size: Dimensions.height30 * 3,
                                  iconSize: Dimensions.height30 +
                                      Dimensions.height45,
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.height30),
                            AccountWdidget(
                              appIcon: AppIcon(
                                icon: Icons.person,
                                backgroundColor: AppColors.mainColor,
                                iconColor: Colors.white,
                                size: Dimensions.height10 * 4,
                                iconSize: Dimensions.height10 * 5 / 2,
                              ),
                              bigText: BigText(
                                  text: controller.userInfoModel.name),
                            ),
                            SizedBox(height: Dimensions.height30),
                            AccountWdidget(
                              appIcon: AppIcon(
                                icon: Icons.phone,
                                backgroundColor: AppColors.yellowColor,
                                iconColor: Colors.white,
                                size: Dimensions.height10 * 4,
                                iconSize: Dimensions.height10 * 5 / 2,
                              ),
                              bigText: BigText(
                                  text: controller.userInfoModel.phone),
                            ),
                            SizedBox(height: Dimensions.height30),
                            AccountWdidget(
                              appIcon: AppIcon(
                                icon: Icons.email,
                                backgroundColor: AppColors.yellowColor,
                                iconColor: Colors.white,
                                size: Dimensions.height10 * 4,
                                iconSize: Dimensions.height10 * 5 / 2,
                              ),
                              bigText: BigText(
                                  text: controller.userInfoModel.email),
                            ),
                            SizedBox(height: Dimensions.height30),
                  GetBuilder<LocationController>(
  builder: (locationController) {
    // Check if the user is logged in and if the address list is empty
    if (_userLoggedIn && locationController.addressList.isEmpty) {
      return GestureDetector(
        onTap: () {
          Get.offNamed(RouteHelper.getAddressPage());
        },
        child: AccountWdidget(
          appIcon: AppIcon(
            icon: Icons.location_on,
            backgroundColor: AppColors.yellowColor,
            iconColor: Colors.white,
            size: Dimensions.height10 * 4,
            iconSize: Dimensions.height10 * 5 / 2,
          ),
          bigText: BigText(text: "Fill your address"),
        ),
      );
    } else {
      // If the address list is not empty, truncate and display the first address
      String address = locationController.addressList.isNotEmpty
          ? locationController.addressList[0].address
          : "No address available";
      String truncatedAddress = address.length > 20 
          ? '${address.substring(0, 20)}...'
          : address;

      return GestureDetector(
        onTap: () {
          Get.offNamed(RouteHelper.getAddressPage());
        },
        child: AccountWdidget(
          appIcon: AppIcon(
            icon: Icons.location_on,
            backgroundColor: AppColors.yellowColor,
            iconColor: Colors.white,
            size: Dimensions.height10 * 4,
            iconSize: Dimensions.height10 * 5 / 2,
          ),
          bigText: BigText(text: truncatedAddress),
        ),
      );
    }
  },
)

,
                            SizedBox(height: Dimensions.height30),
                            AccountWdidget(
                              appIcon: AppIcon(
                                icon: Icons.message,
                                backgroundColor: Colors.redAccent,
                                iconColor: Colors.white,
                                size: Dimensions.height10 * 4,
                                iconSize: Dimensions.height10 * 5 / 2,
                              ),
                              bigText: BigText(text: "hamza"),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (Get.find<AuthController>().hasLogedIn()) {
                                  Get.find<AuthController>()
                                      .clearSharedData();
                                  Get.offNamed(RouteHelper.getInitial());
                                }
                              },
                              child: AccountWdidget(
                                appIcon: AppIcon(
                                  icon: Icons.logout,
                                  backgroundColor:
                                      const Color.fromARGB(255, 47, 0, 149),
                                  iconColor: Colors.white,
                                  size: Dimensions.height10 * 4,
                                  iconSize: Dimensions.height10 * 5 / 2,
                                ),
                                bigText: BigText(text: "Logout"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : CustomLaoded())
              : Center(
                  child: Container(
                    width: double.maxFinite,
                    height: Dimensions.height20,
                    margin: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/image/signn.png"),
                      ),
                    ),
                  ),
                );
        });
      }),
    );
  }
}
