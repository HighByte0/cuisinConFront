import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery_flutter/base/custom_app_bar.dart';
import 'package:food_delivery_flutter/controllers/auth_controller.dart';
import 'package:food_delivery_flutter/controllers/location_controller.dart';
import 'package:food_delivery_flutter/controllers/user_controller.dart';
import 'package:food_delivery_flutter/models/address_model.dart';
import 'package:food_delivery_flutter/pages/address/pick_add_map.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/widgets/app_icon.dart';
import 'package:food_delivery_flutter/widgets/app_text_field.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();
  late bool _isLogged;
  LatLng _initialPosition = LatLng(0, 0);
  

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

 Future<void> _initializeData() async {
  _isLogged = Get.find<AuthController>().hasLogedIn();
  if (_isLogged && Get.find<UserController>().userInfoModel == null) {
    await Get.find<UserController>().getuserinfo();
  }
  if (Get.find<LocationController>().addressList.isNotEmpty) {
    if(Get.find<LocationController>().getUserAddressFromLocalStorage()==""){
      Get.find<LocationController>().saveUserAddress(
        Get.find<LocationController>().addressList.last
      );
    }
    Get.find<LocationController>().getUserAddress();
    _initialPosition = LatLng(
      double.parse(Get.find<LocationController>().getAddress["latitude"]),
      double.parse(Get.find<LocationController>().getAddress["longitude"]),
    );
  } else {
    _getCurrentLocation();
  }

  // Call getAddList to ensure addresses are loaded
  await Get.find<LocationController>().getAddList();
}
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError('Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _updatePosition(position.latitude, position.longitude, true);
  }

  void _updatePosition(double latitude, double longitude, bool fromAddress) {
    setState(() {
      _initialPosition = LatLng(latitude, longitude);
      Get.find<LocationController>().updatePosition(_initialPosition, fromAddress);
    });
  }

  void _selectLocation(LatLng position) {
    _updatePosition(position.latitude, position.longitude, false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar:CustomAppBar(title: "Add Location"),

      body: GetBuilder<UserController>(builder: (userController)
      {
        if(userController.userInfoModel!=null&&_contactPersonName.text.isEmpty){
          _contactPersonName.text='${userController.userInfoModel?.name}';
          _contactPersonNumber.text='${userController.userInfoModel?.phone}';
          if(Get.find<LocationController>().addressList.isNotEmpty){
          _addressController.text=  Get.find<LocationController>().getUserAddress().address;

          }
        }
        return  Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<LocationController>(builder: (locationController) {

    
          if (locationController.loading) {
            return Center(child: CircularProgressIndicator());
          }
          // Update the address controller text directly
          _addressController.text = locationController.pickPlacemark.name ?? locationController.placemark.name ?? '';

          return Column(
  children: [
    Expanded(
      flex: 1,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: _initialPosition,
          initialZoom: 10.0,
          onTap: (_, position) => _selectLocation(position),
          onLongPress: (_, latlng) {
      Get.toNamed(
        RouteHelper.getPickAddMap(),
        arguments: PickAddMap(
          fromSignUp: false,
          fromAddress: true,
        ),
      );
    },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          if (_initialPosition != LatLng(0, 0))
            MarkerLayer(
              markers: [
                Marker(
                  point: _initialPosition,
                  width: 80,
                  height: 80,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
   Padding(
  padding: EdgeInsets.only(top: Dimensions.height10),
  child: SizedBox(
    height: Dimensions.height10 * 4, // Adjusted for better visibility
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal, // This makes it horizontal
      itemCount: locationController.addressTypeList.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(Dimensions.height10),
          margin: EdgeInsets.only(right: Dimensions.width10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius20 / 4),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 35, 46, 208)!,
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              locationController.setAddressTypeIndex(index);
            },
            child: Row(
              children: [
                Icon(
                  index == 0
                      ? Icons.work
                      : index == 1
                          ? Icons.home
                          : Icons.location_on,
                  color: locationController.addressTypeIndex == index
                      ? AppColors.mainColor
                      : Theme.of(context).disabledColor,
                ),
                SizedBox(width: Dimensions.width10),
                Text(
                  locationController.addressTypeList[index],
                  style: TextStyle(
                    color: locationController.addressTypeIndex == index
                        ? AppColors.mainColor
                        : Theme.of(context).disabledColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ),
),
 SizedBox(height: Dimensions.height30),
   
SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        AppTextFiled(
          textEditingController: _addressController,
          hintText: "Your address",
          icon: Icons.map,
        ),
        SizedBox(height: Dimensions.height10),
        AppTextFiled(
          textEditingController: _contactPersonName,
          hintText: "Your name",
          icon: Icons.person,
        ),
        SizedBox(height: Dimensions.height10),
        AppTextFiled(
          textEditingController: _contactPersonNumber,
          hintText: "Your phone",
          icon: Icons.phone,
        ),
      ],
    ),
  ),
),


  ],
);

        }),
      );
      }
      ),
      bottomNavigationBar: GetBuilder<LocationController>(
        builder: (locationController) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             
             
              GestureDetector(
                onTap: () {
                  // controller.addItem(product);
                  AddressModel _addressModel=AddressModel(addressType: locationController.addressTypeList[locationController.addressTypeIndex],
                   contactPersonName: _contactPersonName.text,
                    contactPersonNumber: _contactPersonNumber.text,
                     address: _addressController.text ,
                     lat: locationController.position.latitude.toString()??"", 
                     lon:  locationController.position.longitude.toString()??"", 
                     );
                     locationController.addAddress(_addressModel).then((response){
                      if(response.isSuccess){
                        Get.toNamed(RouteHelper.getInitial());
                        Get.snackbar("Address", "Addes Successfuly");
                      }else{
                        Get.snackbar("Address", "Couldn`t Save Address");
                      }
                     });
                },
                child: Container(
                  height: Dimensions.height20*7 ,
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    top: Dimensions.height20,
                    bottom: Dimensions.height20,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius20 * 2),
                      topRight: Radius.circular(Dimensions.radius20 * 2),
                    ),
                    color: AppColors.buttonBackgroundColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Minus, Plus and Counting of Food
                   
                      // Add Button
                      Container(
                        padding: EdgeInsets.only(
                          top: Dimensions.height15,
                          bottom: Dimensions.height15,
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                        ),
                        // height: Dimensions.height1 * 200,
                        // width: Dimensions.width1 * 200,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: AppColors.mainColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BigText(
                                text: "Save address",
                                color: Colors.white,
                                size: 26,
                                
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
   
    );

  }

 
}
