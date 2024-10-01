import 'dart:convert';



import 'package:food_delivery_flutter/base/no_data_page.dart';
import 'package:food_delivery_flutter/controllers/cart_controller.dart';
import 'package:food_delivery_flutter/models/cart_model.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';

import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:food_delivery_flutter/utils/colors.dart';

import 'package:food_delivery_flutter/widgets/app_icon.dart';

import 'package:food_delivery_flutter/widgets/small_text.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({super.key});

  @override
  Widget build(BuildContext context) {
    var getCartListHistory=Get.find<CartController>()
    .getCartListHistory().reversed.toList();

     Map<String,int> cartItemsPerOrder=Map();

  for(int i=0; i<getCartListHistory.length;i++){
    if(cartItemsPerOrder.containsKey(getCartListHistory[i].time)){
      cartItemsPerOrder.update(getCartListHistory[i].time!,(value)=>++value );
      
    }else{
      cartItemsPerOrder.putIfAbsent(getCartListHistory[i].time!,()=>1);
    }
    
  }
 // print(cartItemsPerOrder);
  List<int> cartOrderList(){
     return cartItemsPerOrder.entries.map((e)=>e.value).toList();
    //  return cartItemsPerOrder.entries.map((e){
    //    return e.value;
    //  }).toList();
  }


  List<String> cartOrderTimeToLsit(){
     return cartItemsPerOrder.entries.map((e)=>e.key).toList();
  
  }

      var listCounter=0;
  Widget timeWidget(int index) {
  if (index < getCartListHistory.length) {
    DateTime parseDte = DateFormat("yyyy-MM-dd HH:mm:ss").parse(getCartListHistory[listCounter].time!);
    var inputDate = DateTime.parse(parseDte.toString());
    var outputFormat = DateFormat("MM/dd/yyyy hh:mm a");
    var outputDat = outputFormat.format(inputDate);
    return BigText(text: outputDat);
  } else {
    // Return a default widget if index is out of range
    return Container(); // You can return any default widget here
  }
}

 // print(cartItemsPerOrder.length);
   List<int> itemsPerOrder=cartOrderList();


   
    return  Scaffold(
     
      
      
      
      body: Column(
        
        
        
        children: [
          Container(
            
            
            
            height: Dimensions.height10*10,
            
            color: AppColors.mainColor,
            width: double.maxFinite,
            padding: EdgeInsets.only(top: Dimensions.width30+15),
            child: Row(
              
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
              BigText(text: "cart history" ,color: Colors.white,),
              AppIcon(icon: Icons.shopping_cart_outlined,
              iconColor: AppColors.mainColor,
              backgroundColor: AppColors.yellowColor
              ,),
            ],),
          ),
          GetBuilder<CartController>(builder: (_cartController){
            return
            _cartController.getCartListHistory().length>0?Expanded(
            child: Container(
             
           
              // margin: EdgeInsets.only(
              //   top:Dimensions.height20,
              //   bottom: Dimensions.height20,
              //   left: Dimensions.width20,
              //   right: Dimensions.width20,
            
              // ),
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView(
                  children: [
                    for(int i=0; i<itemsPerOrder.length ;i++)
                    Container(
                  
                      height: Dimensions.height30*5,
                     
                      child: Column(
                        
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          timeWidget(listCounter),// drna had l3yba hit mbghtch tkhdm had l3yba===>>>:  (()  {}())
                        
                       
                        SizedBox(height: Dimensions.height10),
                        Row( 
                          
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              
                              direction: Axis.horizontal,
                              children:List.generate(itemsPerOrder[i], (index) {
                                if(listCounter<getCartListHistory.length){
                                  listCounter++;
                                }
                                return index<=2?Container(
                                height: Dimensions.height20*4,
                                width: Dimensions.width20*4,
                                margin: EdgeInsets.only(
                                  right: Dimensions.width5/2
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                                  
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      AppConstants.IMAGE_UPLOADS_URL+getCartListHistory[listCounter-1].img!
                                   
                
                                  )
                                  )
                                ),
                                ):Container();
                              })
                            ),
                            Container(
                            
                              height: Dimensions.height20*4.5,
                             // padding: EdgeInsets.only(left: Dimensions.width10),
                             margin: EdgeInsets.only(right: Dimensions.width10/2),
                              child: Column(
                                
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                SmallText(text: "Total",color: AppColors.mainColor,),
                                BigText(text: itemsPerOrder[i].toString()+"Items",
                                color: AppColors.mainColor,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    var orederTime=cartOrderTimeToLsit();
                                    

                                     Map<int,CartModel> moreOrder={};
                                     for(int j=0;j<getCartListHistory.length; j++){
                                      if(getCartListHistory[j].time==orederTime[i]){
                                          moreOrder.putIfAbsent(getCartListHistory[j].id!, () => 
                                           CartModel.fromJson(jsonDecode(jsonEncode(getCartListHistory[j]) ))); //had as String rak nta li zdtiha
                                       
                                      }
                                    }
                                    // print("ds"+orederTime[i].toString());
                                      Get.find<CartController>().setItems=moreOrder;
                                      Get.find<CartController>().addToCartList();
                                 Get.toNamed(RouteHelper.getCartPage());
                                    
                                  }
                                  ,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.width10,
                                    vertical: Dimensions.height10/2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                                      border: Border.all(width: 1,color: AppColors.mainColor)
                                    ),
                                    child: BigText(text: "one more",color: AppColors.mainColor,),
                                  ),
                                )
                              ],),
                            )
                          ],
                        )
                      ],),
                      margin: EdgeInsets.only(
                            bottom: Dimensions.height20,
                      ),
                    )
                    
                  ],
                ),
              ),
            ),
          ):Container(
            height: MediaQuery.of(context).size.height/1.5,
            child: NoData(text: "your History is empty !",imgPath: "assets/image/empty.jpg",));

          })

      ],),
    );

  }
}