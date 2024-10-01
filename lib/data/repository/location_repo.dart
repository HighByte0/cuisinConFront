import 'package:food_delivery_flutter/data/api/api_client.dart';
import 'package:food_delivery_flutter/models/address_model.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocatonRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  LocatonRepo({required this.apiClient, required this.sharedPreferences});

  bool loading = false;
  late Position _position;
  late Position _pickPosition;
  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();
  List<AddressModel> addressModel = [];

  // Fetch address from reverse geocoding using Laravel API
  Future<String> getAddrssFromGeoCode(LatLng latLng) async {
    String _address = "No Location Found";

    final response = await apiClient.getData(
      '${AppConstants.GEOCODE_URI}?lat=${latLng.latitude}&lng=${latLng.longitude}'
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _address = data['display_name'] ?? "No Location Found";
      print("dsda");
      print(_address);
    } else {
      print("Failed to load address");
    }
    return _address;
  }
   getUserAdress(){
    return sharedPreferences.getString(AppConstants.USER_ADDRESS)??"";


  }

  Future<Response> addAddress(AddressModel addressModel)async{
    return await apiClient.postData(AppConstants.ADD_USER_ADDRESS, addressModel.toJson());
  }

  Future<Response>getAllAddress()async{
    return await apiClient.getData(AppConstants.ADD_LIST_URI);  
  }
  
  Future<bool>saveUserAdderss(String address)async{
    apiClient.updateHeader(sharedPreferences.getString(AppConstants.TOKEN)!);
    return await sharedPreferences.setString(AppConstants.USER_ADDRESS, address);
  }
  Future<Response>getZone(String lat ,String lng)async{
    return await apiClient.getData('${AppConstants.ZONE_URI}?lat=$lat&lng=$lng');
  }



}
