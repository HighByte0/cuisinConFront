

import 'package:food_delivery_flutter/data/api/api_client.dart';

import 'package:food_delivery_flutter/models/signup_body_model.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> registration(SignUpBody signUpBody )async {
 return await  apiClient.postData(AppConstants.REGISTRATION_URi, signUpBody.toJson());
  }

  Future<Response> login(String email ,String password )async {
 return await  apiClient.postData(AppConstants.LOGIN_URi, {"email": email, "password": password});
  }

 Future<bool> saveUserToke(String token)async{
    apiClient.token=token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);

  }
  Future<void>saveNumberAndPass(String number ,String password)async{
    try{
       await sharedPreferences.setString(AppConstants.PHONE, number);
        await sharedPreferences.setString(AppConstants. PASSWORD, password);

    }catch(e){
      throw e;
    }
  }
  Future<String> getUserToken()async{
    return  sharedPreferences.getString(AppConstants.TOKEN)??"None";
  }

  bool hasLogedIn(){
    print(AppConstants.TOKEN);
    return  sharedPreferences.containsKey(AppConstants.TOKEN);
  }
  bool clearSharedData(){
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.PASSWORD);
    sharedPreferences.remove(AppConstants.PHONE);
    apiClient.token='';
    apiClient.updateHeader('');
    return true;
  }

  Future<Response> updateToken() async {
  String? deviceToken;

  try {
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      // Request iOS notification permissions
      final NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get and save the device token
        deviceToken = await saveDeviceToken();
        print("My token is: $deviceToken");
      } else {
        print("User declined or has not accepted notification permissions.");
      }
    } else {
      // Get and save the device token for Android
      deviceToken = await saveDeviceToken();
      print("My token is: $deviceToken");

      // if (!GetPlatform.isWeb) {
      //   // Subscribe to a topic (optional)
      //   await FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
      // }
    }

    // Send the device token to your server
    return await apiClient.postData(
      AppConstants.TOKEN_URI,
      {"method": "put", "cm_firebase_token": deviceToken},
    );
  } catch (e) {
    print("Error updating token: $e");
    rethrow;
  }
}
Future<String?> saveDeviceToken() async {
  String? deviceToken;

  try {
    if (GetPlatform.isWeb) {
      // Request permission for web
      await FirebaseMessaging.instance.requestPermission();
      // Retrieve the device token
      deviceToken = await FirebaseMessaging.instance.getToken();
    } else {
      // Handle other platforms (e.g., iOS, Android) if necessary
      deviceToken = await FirebaseMessaging.instance.getToken();
    }

    if (deviceToken != null) {
      print("Device Token: $deviceToken");
    } else {
      print("Failed to get device token.");
    }

    return deviceToken;
  } catch (e) {
    print("Error retrieving device token: ${e.toString()}");
    return null;
  }
}
}