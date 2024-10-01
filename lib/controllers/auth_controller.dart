
import 'package:food_delivery_flutter/controllers/user_controller.dart';
import 'package:food_delivery_flutter/data/repository/auth_repo.dart';
import 'package:food_delivery_flutter/models/response_model.dart';

import 'package:food_delivery_flutter/models/signup_body_model.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';

import 'package:get/get.dart';
import 'dart:developer' as dev;

class AuthController extends GetxController implements GetxService{
  final AuthRepo authRepo ;
  AuthController({
    required this.authRepo
  });
  bool _isLoaded=false;
  bool get isLoaded=>_isLoaded;
  Future<ResponseModel> registration(SignUpBody signUpBody)async{
    print("gettting token");

   print( authRepo.getUserToken().toString());
    _isLoaded=true;
    update();
    ResponseModel responseModel;
   Response response= await authRepo.registration(signUpBody);
   if(response.statusCode==200){
   
    print(response.body["token"]);
    responseModel=ResponseModel(true, response.body["token"]);


   }else{
     responseModel=ResponseModel(false, response.statusText!);



   }
   _isLoaded=false;
   update();
   return responseModel;

  }Future<ResponseModel> login(String email, String password) async {
  try {
    print("Getting token");
    dev.log("Token before request: ${authRepo.getUserToken()}");
    
    // Set loading state
    _isLoaded = true;
    update();

    // Call the login method from authRepo
    Response response = await authRepo.login(email, password);

    // Check the response status code
    if (response.statusCode == 200) {
      print("Back token");
      
      // Verify that the response body contains the token
      if (response.body is Map<String, dynamic> && response.body.containsKey("token")) {
        String token = response.body["token"];
        print("Back token: $token");

        // Save the token
        authRepo.saveUserToke(token);
        
        // Update the responseModel
        ResponseModel responseModel = ResponseModel(true, token);
        Get.find<UserController>().getuserinfo();

        return responseModel;
      } else {
        print("Token not found in response body");
        return ResponseModel(false, "Token not found in response");
      }
    } else if (response.statusCode == 403) {
      // Handle blocked account
      print("Account is blocked");
      Get.offNamed(RouteHelper.blockPage); // Redirect to blocked page
      return ResponseModel(false, "Account is blocked");
    } else {
      print("Failed to login: ${response.statusText}");
      return ResponseModel(false, response.statusText ?? "Unknown error");
    }
  } catch (e) {
    print("Error during login: $e");
    return ResponseModel(false, "Failed to login: ${e.toString()}");
  } finally {
    // Ensure loading state is reset
    _isLoaded = false;
    update();
  }
}


      void saveNumberAndPass(String number ,String password){
   authRepo.saveNumberAndPass(number, password);
   }
   
   bool hasLogedIn(){
    return authRepo.hasLogedIn();
    }
   bool clearSharedData(){
     return authRepo.clearSharedData();
    }

  // Future<void>updateToken()async{
  //   await authRepo.updateToken();
  // }

 
}