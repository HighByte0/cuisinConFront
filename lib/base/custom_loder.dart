
import 'package:flutter/material.dart';

import 'package:food_delivery_flutter/utils/dimensions.dart';


class CustomLaoded extends StatelessWidget  implements PreferredSizeWidget{
  
  const CustomLaoded({super.key});

  @override
  Widget build(BuildContext context) {

    return  Center(
      child: Container(
        height: Dimensions.height20*5,
        width: Dimensions.height20*5,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.height20*5/2),  color: Color.fromARGB(255, 61, 9, 113),),
      
        alignment: Alignment.center,
        child:const CircularProgressIndicator(color: Colors.white,)
      ),
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(500, 500);
}