import 'package:food_delivery_flutter/data/api/api_client.dart';
import 'package:food_delivery_flutter/models/place_order_model.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:get/get.dart';

class OrderRepo{
  final ApiClient apiClient;
  OrderRepo({required this.apiClient});
  

  Future<Response> placeOrder(PlaceOrderBody placeOrderBody)async{
    return await
    apiClient.postData(AppConstants.PLACE_ORDER_URI,placeOrderBody.toJson());
  }
    Future<Response> getOrderList()async{
    return await
    apiClient.getData(AppConstants.ORDER_LIST);
  }

  
}