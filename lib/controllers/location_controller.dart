// import 'package:flutter_map/flutter_map.dart';
import 'package:food_delivery_flutter/data/repository/location_repo.dart';
import 'package:food_delivery_flutter/models/address_model.dart';
import 'package:food_delivery_flutter/models/response_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart'; // Use latlong2 package for LatLng
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationController extends GetxController implements GetxService {
  final LocatonRepo locationRepo;
  late LatLng _initialPosition;
  RxBool _loading = false.obs;
  late Position _position;
  Position? _pickPosition;
  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();
  List<AddressModel> _addressList = [];
  List<AddressModel> _allAddressList = [];
  List<String> _addressTypeList = ["Bureau", "Appartement", "Autre"];
  int _addressTypeIndex = 0;

  bool _updateAddressData = true;
  bool _changeAddress = true;
  late Map<String, dynamic> _getAddress;

  bool get loading => _loading.value;
  Position get position => _position;
  Position? get pickPosition => _pickPosition;
  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;
  List<AddressModel> get addressList => _addressList;
  List<String> get addressTypeList => _addressTypeList;
  int get addressTypeIndex => _addressTypeIndex;

  Map get getAddress => _getAddress;
  bool _isLoading=true;
  bool get isLoading=>_isLoading;

  //wach  khona kyn fzon li hna khdamin fiha wla la 
  bool _inZone=false;
  bool get inZone=> _inZone;
//binma lcnx tji mnwrich lbuttona
  bool _buttonDisabled=true;
  bool get buttonDisabled=>_buttonDisabled;




  LocationController({required this.locationRepo}) {
    _initialPosition = LatLng(0, 0); // Default initialization
    getAddList(); // Load address list on initialization
  }

 

  void updatePosition(LatLng  initialPosition, bool fromAddress) async {
    if (_updateAddressData) {
      _loading.value = true;
      try {
        if (fromAddress) {
          _position = Position(
              latitude: initialPosition.latitude,
              longitude: initialPosition.longitude,
              timestamp: DateTime.now(),
              accuracy: 1,
              altitude: 1,
              heading: 1,
              speed: 1,
              speedAccuracy: 1,
              altitudeAccuracy: 1,
              headingAccuracy: 1
          );
        } else {
          _pickPosition = Position(
              latitude: initialPosition.latitude,
              longitude: initialPosition.longitude,
              timestamp: DateTime.now(),
              accuracy: 1,
              altitude: 1,
              heading: 1,
              speed: 1,
              speedAccuracy: 1,
              altitudeAccuracy: 1,
              headingAccuracy: 1
          );
        }
        ResponseModel _responseModel=
        await getZone(position.latitude.toString(), position.longitude.toString(), false);


      _buttonDisabled=! _responseModel.isSuccess;
        if (_changeAddress) {
          String _address = await getAddressFromGeocode(
            LatLng(
            initialPosition.latitude,
            initialPosition.longitude,
          ));
          fromAddress ? _placemark = Placemark(name: _address) : _pickPlacemark = Placemark(name: _address);
        }
      } catch (e) {
        print(e);
      } 
        _loading.value = false;
        update();
    }
    else{
      _updateAddressData=true;
    }
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String address = "No Location Found";
    final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=${latLng.latitude}&lon=${latLng.longitude}')
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      address = data['display_name'] ?? "No Location Found";
      print(address);
    } else {
      print("Failed to load address, status code: ${response.statusCode}");
    }

    return address;
  }

  AddressModel getUserAddress() {
    late AddressModel addressModel;
    _getAddress = jsonDecode(locationRepo.getUserAdress());
    try {
      addressModel = AddressModel.fromJson(_getAddress);
    } catch (e) {
      print(e);
    }
    return addressModel;
  }

  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    _allAddressList=[];



    update();
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading.value = true;

    Response response = await locationRepo.addAddress(addressModel);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      await getAddList();
      String message = response.body["message"]; // Corrected from "messge"
      responseModel = ResponseModel(true, message);
      saveUserAddress(addressModel);
    } else {
      print("Couldn't save address");
      responseModel = ResponseModel(false, response.statusText!);
    }

    _loading.value = false; // Ensure loading is set to false after the operation
    return responseModel;
  }

  Future<void> getAddList() async {
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      List<dynamic> responseData = response.body;
      _addressList = responseData.map((address) => AddressModel.fromJson(address)).toList();

      _allAddressList = List.from(_addressList);  // If you want a separate copy
      print(_allAddressList);  // If you want a separate copy

    } else {
      _addressList = [];
      _allAddressList = [];
    }
    update();
  }

  Future<bool> saveUserAddress(AddressModel addressModel) async {
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveUserAdderss(userAddress);
  }

  String getUserAddressFromLocalStorage(){
    return locationRepo.getUserAdress();
  }

  void setAddData() {
    if (_pickPosition != null) {
      _position = _pickPosition!;
      _placemark = _pickPlacemark;
      _updateAddressData = false;
      update();
    } else {
      print("Pick position is not set");
    }
  }


Future<ResponseModel>getZone(String  lat,String lng,bool markerLoad)async{
  late ResponseModel _responseModel;


if(markerLoad){

  _isLoading=true;

}else{
  _isLoading=true;
}

update();
await  Future.delayed(Duration(seconds: 1),(){
    _responseModel=ResponseModel(true,"Success");
  if(markerLoad){
  _isLoading=false;

}else{
  _isLoading=false;
}
_inZone=true;

});
update();
return _responseModel;
}

 Future<List<AddressModel>> listAdd() async {
    Response response = await locationRepo.getAllAddress();

    if (response.statusCode == 200) {
      List<dynamic> data = response.body;

      // Convert the response body to a list of AddressModel
      List<AddressModel> addressList = data.map((json) => AddressModel.fromJson(json)).toList();
      
      return addressList;
    } else {
      return [];
    }
  }

  }
