import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:get/get.dart';

void ShowCustomMesage(String message, {bool isError=true,String title="Error", Color color=Colors.green } ){
  Get.snackbar(title, message,
  titleText: BigText(text: title, color:const Color.fromARGB(255, 255, 255, 255)),
  messageText: Text(message ,style: TextStyle(
    color:Colors.white,
  ),
  ),
  colorText: Colors.white,
  snackPosition: SnackPosition.TOP,
  backgroundColor:message=="Your registration went well"? Color.fromARGB(255, 20, 237, 96): Colors.redAccent
  
  );

}