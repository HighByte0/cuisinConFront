import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/base/custom_button.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:get/get.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';

class OrderSuccessPage extends StatelessWidget {
  final int status;
  final int orderID;
  

  OrderSuccessPage({ required this.orderID,required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == 0) {
      Future.delayed(Duration(seconds: 2), () {
        // You can show a dialog or perform any action after a delay
        // Get.dialog(PaymentFailedDialog(orderID: orderID), barrierDismissible: false);
      });
    }

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              // Image.asset(
              //   status == 1 ? "assets/image/checked.png" : "assets/image/warning.png",
              //   width: 100,
              //   height: 100,
              // ),
              Icon( status==1? Icons.check_circle_outline:Icons.warning_amber_outlined,
              size: 100,
              color: Color.fromARGB(255, 128, 10, 231),
              ),
              SizedBox(height: Dimensions.height15),
              Text(
                status == 1 ? 'You placed the order successfully' : 'Your order failed',
                style: TextStyle(fontSize: Dimensions.font20/2+5),
              ),
              SizedBox(height: Dimensions.height20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.height20, vertical: Dimensions.height20),
                child: Text(
                  status == 1 ? 'Successful order' : 'Failed order',
                  style: TextStyle(fontSize: Dimensions.font20, color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Padding(
                padding: EdgeInsets.all(Dimensions.height20),
                child:  CustomButton(
                  buttonText: 'Back to Home',
                  onPressed: () => Get.offAndToNamed(RouteHelper.getInitial()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
