import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery_flutter/base/custom_loder.dart';
import 'package:food_delivery_flutter/base/show_custom_mesage.dart';
import 'package:food_delivery_flutter/controllers/auth_controller.dart';
import 'package:food_delivery_flutter/models/signup_body_model.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/colors.dart';

import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/widgets/app_text_field.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // var authController=Get.find<AuthController>();
    var emailController=TextEditingController();
      var passwordController=TextEditingController();
      var verifPasswordController=TextEditingController();
        var nameController=TextEditingController();
          var phoneController=TextEditingController();

          var signUpImage=[
            "t.png",
            "f.png",
            "g.png",
          ];
         void _validation(AuthController authController) {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String verifPassword = verifPasswordController.text.trim();

    if (name.isEmpty) {
        ShowCustomMesage("The field name is empty", title: "Name");
    } else if (email.isEmpty) {
        ShowCustomMesage("The field email is empty", title: "Email");
    }else if(!GetUtils.isEmail(email)){
        ShowCustomMesage("Please enter a valid Email", title: "Email");
    } 
    else if (password != verifPassword) {
        ShowCustomMesage("Passwords do not match", title: "Password");
    } else if (phone.isEmpty) {
        ShowCustomMesage("The field phone number is empty", title: "Phone Number");
    } else if(num.tryParse(phone)==null || phone.length>10 || phone.length<10)  {
        ShowCustomMesage("Please enter a valid phone number", title: "Phone Number");
    } else if (password.length < 6) {
        ShowCustomMesage("Password must be at least 6 characters long", title: "Password");
    } else {

        
        SignUpBody signUpBody =SignUpBody(name: name,
        phone: phone,
        email: email,
        password: password);
      authController.registration(signUpBody).then((status){
        if(status.isSuccess){
        Get.offNamed(RouteHelper.getSignInPage());
        }else{
          ShowCustomMesage(status.message);
        }
      });

    }
}



    
    return  Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (_authController) {
      return  !_authController.isLoaded? SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
        
          )
          ,
          AppTextFiled(textEditingController: emailController, hintText: "email", icon: Icons.email, obscureText: false,),
          SizedBox(height: Dimensions.height10,),
            AppTextFiled(textEditingController: passwordController, hintText: "password", icon: Icons.password_sharp,obscureText: true,),
            
          SizedBox(height: Dimensions.height10,),
               AppTextFiled(textEditingController: verifPasswordController, hintText: "confirm Password", icon: Icons.password_sharp,obscureText: true),
          SizedBox(height: Dimensions.height10,),
            AppTextFiled(textEditingController: nameController, hintText: "Name", icon: Icons.person),
          SizedBox(height: Dimensions.height10,),
            AppTextFiled(textEditingController: phoneController, hintText: "Phone", icon: Icons.phone),
          SizedBox(height: Dimensions.height20,),
          GestureDetector(
            onTap:() {
              _validation(_authController);

              
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
                  text: "Sign up",
                size: Dimensions.font20,
                color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height10,),
          RichText(
            text: TextSpan(
            recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
            text: "Have an account already",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: Dimensions.font20/2,
            ),
           
        
          ),
        
          ),
          SizedBox(
            height: Dimensions.screenHight*0.05,
          ),
          RichText(
            text: TextSpan(
            recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
            text: "Sign up with : ",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: Dimensions.font16,
            ),
           
        
          ),
        
          ),
        Wrap(
          children: List.generate(3, (index) {
            return CircleAvatar(
        radius: Dimensions.radius30,
        backgroundImage: AssetImage("assets/image/"+signUpImage[index]),
            );
          }),
        )
        
        
        ],
        ),
      ):CustomLaoded();
      
        
      },)
    );
      //   var emailController=TextEditingController();
      // var passwordController=TextEditingController();
      // var verifPasswordController=TextEditingController();
      //   var nameController=TextEditingController();
      //     var phoneController=TextEditingController();
   
   
  }
}