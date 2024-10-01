import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/utils/colors.dart';

import 'package:food_delivery_flutter/utils/dimensions.dart';

class AppTextFiled extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
 final  bool obscureText;
  //add final format parametres=> ktswb lk blkhf les construtorrr
  const AppTextFiled({super.key, required this.textEditingController, required this.hintText, required this.icon,  this.obscureText=false,});


  @override
  Widget build(BuildContext context) {
    return Container(
          margin:EdgeInsets.only(left: Dimensions.width20,
          right: Dimensions.height20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius:7,
                offset: Offset(1, 1),
                color: Color(0xFF373298).withOpacity(0.2)
              )
            ]
          ),
          child: TextField(
            obscureText: obscureText,
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: hintText,
              
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radius20),
              borderSide: BorderSide(
                width: 1,
                color: Colors.white
              )
              ),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radius20),

              borderSide: BorderSide(
                width: 1,
                color: Colors.white
              ),
              
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radius20),
             
              ),

            
              prefixIcon: Icon(icon ,
               color: AppColors.yellowColor,

               )
            ),
          ),
        );
  }
}