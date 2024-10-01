import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/controllers/order_controller.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/utils/styles.dart';
import 'dart:developer' as dev;

import 'package:get/get.dart';


class PaymentOptionButton extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subtitle;
  final int index;
  const PaymentOptionButton({super.key, required this.iconData, required this.title, required this.subtitle, required this.index});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<OrderController>(builder:(orderController){
       bool _selected =orderController.paymentIndex==index;
return InkWell(
 
      onTap: () => orderController.setPayment(index),
      child: Container(
        padding: EdgeInsets.only(bottom: Dimensions.width10/2),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radius20*4),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,blurRadius: 5,spreadRadius: 1
          )
        ]
        
        
        ),
        child: ListTile(
          leading: Icon(
           iconData,
            size: 40,
            color: _selected?AppColors.mainColor:Theme.of(context).disabledColor,
          ),
          title: Text(title,
           style: robotoMedium.copyWith(fontSize: Dimensions.font20),
          ),
          subtitle: Text(subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.font12,
             color: Theme.of(context).disabledColor,
      
          ),
          ),
          trailing:_selected? const Icon(Icons.check_circle,color: Color.fromRGBO(120, 5, 122, 1),):null
         
        ),
      ),
    );
 
    } );
  }
}