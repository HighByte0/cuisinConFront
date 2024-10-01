import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:food_delivery_flutter/widgets/icon_and_text.dart';
import 'package:food_delivery_flutter/widgets/small_text.dart';

class AppColumn extends StatelessWidget {
  final String foodTitle;
  const AppColumn({Key? key, required this.foodTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         BigText(text: "Auto-entrepreneur ", color: Colors.amberAccent),
        // Food Name
        BigText(text: foodTitle, size: Dimensions.font26),
        SizedBox(height: Dimensions.height10),
        // Rating and Comments
        Row(
          children: [
           
           
          ],
        ),
        SizedBox(height: Dimensions.height15),
        //Spicy IconText, Distance IconText and Cooking Time IconText
        

        // Spicy, Distance and Time Cooking
      ],
    );
  }
}
