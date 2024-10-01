import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/widgets/app_icon.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';

// ignore: must_be_immutable
class AccountWdidget extends StatelessWidget {
  AppIcon appIcon;
  BigText bigText;
  
   AccountWdidget({Key? key ,required this.appIcon ,required this.bigText }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.only(left: Dimensions.width30,
      top: Dimensions.width15,
      bottom: Dimensions.width10),
      child: Row(children: [
        appIcon,
        SizedBox(width: Dimensions.width10,),
        bigText,
      ],),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
        BoxShadow(
          
          blurRadius: 1,
          offset: Offset(0,2),
          color: Colors.grey.withOpacity(0.2)
        )
      ]),
    );
  }
}