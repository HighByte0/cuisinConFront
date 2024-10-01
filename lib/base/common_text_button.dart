import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';

class CommonTextButton extends StatelessWidget {
  final String text ;
  const CommonTextButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return  Container(
                      padding: EdgeInsets.only(
                        top: Dimensions.height15,
                        bottom: Dimensions.height15,
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                      ),
                      // height: Dimensions.height1 * 200,
                      // width: Dimensions.width1 * 200,
                      decoration: BoxDecoration(
                        boxShadow:[
                          BoxShadow(
                          offset: Offset(0, 5),
                          blurRadius: 10,
                          color: Color.fromARGB(255, 131, 175, 201)
                        ),
                          
                        ] ,
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        color: AppColors.mainColor,
                      ),
              
                      child: Center(
                        child: BigText(
                          text:text,
                          color: Colors.white,
                        ),
                      ),
                    );
  }
}