import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery_flutter/base/custom_loder.dart';
import 'package:food_delivery_flutter/base/show_custom_mesage.dart';
import 'package:food_delivery_flutter/controllers/auth_controller.dart';
import 'package:food_delivery_flutter/models/signup_body_model.dart';
import 'package:food_delivery_flutter/pages/auth/sign_up_page.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/colors.dart';

import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/widgets/app_text_field.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:get/get.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController=TextEditingController();
      var passwordController=TextEditingController();
       void _validation(AuthController authController) {
  
    String email = emailController.text.trim();

    String password = passwordController.text.trim();
 

     if (email.isEmpty) {
        ShowCustomMesage("The field email is empty", title: "Email");
    }
  
    else if (password.length < 6) {
        ShowCustomMesage("Password must be at least 6 characters long", title: "Password");
    } else {

        

      authController.login(email,password).then((status){
        if(status.isSuccess){
       Get.toNamed(RouteHelper.getCartPage());
        }else{
          ShowCustomMesage(status.message);
        }
      });

    }
}


  
    return  Scaffold(
      backgroundColor: Colors.white,
      body:GetBuilder<AuthController>(builder: (controller) {
        return !controller.isLoaded? SingleChildScrollView(
        child: Column(
        
          children: [
            SizedBox(height: Dimensions.screenHight*0.05,),
          Container(
            
            height:  Dimensions.screenHight*0.25,
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: Dimensions.font20*4,
                backgroundImage:
              AssetImage("assets/image/cc.png"
              
              ) ,
              ),
            ),
        
          ),
          //hello word
          Container(
            margin: EdgeInsets.only(left: Dimensions.screenHight*0.02),
            width: double.maxFinite,
            child: Column(

                 crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text("healthy food ",
              style: TextStyle(
                fontSize: Dimensions.font20*2,
                fontWeight: FontWeight.bold
              ),),
                  Text("Healthy day, healthy life",
              style: TextStyle(
                fontSize: Dimensions.font20/2,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),),
              
            
              
            ],),
          ),
           SizedBox(height: Dimensions.height30,),
          
          AppTextFiled(textEditingController: emailController, hintText: "email", icon: Icons.email, obscureText: false,),
          SizedBox(height: Dimensions.height10,),
            AppTextFiled(textEditingController: passwordController, hintText: "password", icon: Icons.password_sharp, obscureText: true,
            
            ),
       
           SizedBox(height: Dimensions.height10,),
           Row(
            children: [
              Expanded(child: Container()),
                 RichText(
            text: TextSpan(
            recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
            text: "Sign into your account",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: Dimensions.font20/2,
            ),



           
        
          ),
        
          ),
            SizedBox(height: Dimensions.screenHight*0.05,)
            ],

           ),
           
          GestureDetector(
            onTap: () {
              _validation(controller);
            },
            child: Container(
              width: Dimensions.width30*5,
              height: Dimensions.height100/2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                color: AppColors.mainColor
              ),
              
              child: Center(
                child: BigText(
                  text: "Sign in",
                size: Dimensions.font20,
                color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height10,),
       
          SizedBox(
            height: Dimensions.screenHight*0.05,
          ),
          RichText(
            text: TextSpan(
  
            text: "Don't have  an accounte?",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: Dimensions.font16,
            ),
            children: [
              TextSpan(
            recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>SignUpPage(),transition: Transition.zoom),
            text: "Create",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 11, 83, 207),
              fontSize: Dimensions.font16,
              
            ),

              
           ) ]
           
        
          ),
          
        
          ),
       
        
        
        ],
        ),
      ):CustomLaoded();
      },)
    );
  }
}