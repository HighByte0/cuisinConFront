import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/controllers/order_controller.dart';
import 'package:food_delivery_flutter/models/order_model.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/utils/styles.dart';
import 'package:get/get.dart';

class ViewOrder extends StatelessWidget {
  final bool isCurrent;

  const ViewOrder({super.key, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OrderController>(builder: (orderController) {
        // Check if the data is still loading
        if (!orderController.isLoading) {
          late List<OrderModel> orderList;

          // Determine if displaying current orders or history orders
          if (isCurrent && orderController.currentOrderList.isNotEmpty) {
            orderList = orderController.currentOrderList.reversed.toList();
          } else if (!isCurrent && orderController.historyOrderList.isNotEmpty) {
            orderList = orderController.historyOrderList.reversed.toList();
          } else {
            return const Center(child: Text('No orders available'));
          }

          // Display the order list
          return SizedBox(
            width: Dimensions.screenWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width10 / 2,
                vertical: Dimensions.height10 / 2,
              ),
              child: ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // Handle tap event
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height10 / 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "#order ID: ",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.font12,
                                ),
                              ),
                              SizedBox(width: Dimensions.width10 / 2),
                              Text('#${orderList[index].id.toString()}'),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.radius20 / 4,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.width10,
                                      vertical: Dimensions.width10 / 2,
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.all(Dimensions.height2),
                                      child: Text(
                                        '${orderList[index].orderStatus ?? 'Unknown'}',
                                        style: robotoMedium.copyWith(
                                          fontSize: Dimensions.font12,
                                          color: Theme.of(context).cardColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height10 / 2),
                                  InkWell(
                                    onTap: () {
                                      // Handle "Track order" click
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.width10,
                                        vertical: Dimensions.width10 / 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.radius20 / 4,
                                        ),
                                        border: Border.all(
                                          width: 1,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/image/tracking.png",
                                            height: 15,
                                            width: 15,
                                            color: const Color.fromARGB(255, 96, 7, 230),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(
                                              Dimensions.height10 / 2,
                                            ),
                                            child: Text(
                                              "Track order",
                                              style: robotoMedium.copyWith(
                                                fontSize: Dimensions.font12,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.height10),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          // Show loading indicator while the data is being fetched
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
