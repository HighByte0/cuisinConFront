import 'package:food_delivery_flutter/data/repository/order_repo.dart';
import 'package:food_delivery_flutter/models/order_model.dart';
import 'package:food_delivery_flutter/models/place_order_model.dart';
import 'package:get/get.dart'; // Ensure GetX is imported
import 'dart:developer' as dev;

class OrderController extends GetxController implements GetxService {



  bool _isLoading=false;
  OrderRepo orderRepo;
  int _paymentIndex=0;
  int get paymentIndex=>_paymentIndex;
 
  OrderController({required this.orderRepo});
  bool get isLoading =>_isLoading; 
  String _foodNote="good";
  String get note => _foodNote;


  Future<void> placeOrder(Function callBack ,PlaceOrderBody placeOrderBody)async{
    _isLoading=true;
 Response response=await   orderRepo.placeOrder(placeOrderBody);
 if(response.statusCode==200){
  _isLoading=false;
  String message= response.body['message'];

  String orderID=response.body['oreder_id'].toString();
  callBack(true,message,orderID);
 }
else{
    callBack(false,response.statusText!,"-1");
}
  }
     late List<OrderModel>_historyOrderList;
      List<OrderModel> get historyOrderList=>_historyOrderList;

   late List<OrderModel> _currentOrderList = [];
List<OrderModel> get currentOrderList => _currentOrderList;


  Future<void>getOrderList()async{
    _isLoading=true;
    Response response=await orderRepo.getOrderList();
    if(response.statusCode==200){
      _currentOrderList=[];
      _historyOrderList=[];
      response.body.forEach((order){
        OrderModel orderModel =OrderModel.fromJson(order);
          if(orderModel.orderStatus=='pending'||
          orderModel.orderStatus=='accepted'||
          orderModel.orderStatus=='processing'||
            orderModel.orderStatus=='handover'||
            orderModel.orderStatus=='picked_up'
        ){
          _currentOrderList.add(orderModel);

        }else{
          _historyOrderList.add(orderModel);
        }


      }
      );

    }else{
      _historyOrderList=[];
      _currentOrderList=[];

    }
    _isLoading=false;
    // print("length"+_currentOrderList.length.toString());
    dev.log("length"+_historyOrderList.length.toString());
    update();
    // return response;
  }
  void setPayment(int index){
    _paymentIndex=index;
    update();
  }
  void setFoodNotw(String note){
    _foodNote=note;
    dev.log(_foodNote);
    update();
  }
}
