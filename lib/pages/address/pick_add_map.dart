import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/base/custom_button.dart';
import 'package:food_delivery_flutter/controllers/location_controller.dart';
import 'package:food_delivery_flutter/models/address_model.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class PickAddMap extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddress;

  PickAddMap({required this.fromSignUp, required this.fromAddress});

  @override
  State<PickAddMap> createState() => _PickAddMapState();
}

class _PickAddMapState extends State<PickAddMap> {
  late LatLng _initialPosition;
  final LocationController locationController = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    // Set initial position based on addressList
    if (locationController.addressList.isEmpty) {
      _initialPosition = LatLng(33.95342, -7.65211);
    } else {
      _initialPosition = LatLng(
        double.parse(locationController.getAddress["latitude"]),
        double.parse(locationController.getAddress["longitude"]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick Address')),
      body: SafeArea(
        child: Center(
          child: Obx(() {
            // Ensure that the map updates when locationController changes
            return locationController.loading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        FlutterMap(
                          options: MapOptions(
                            initialCenter: _initialPosition,
                            initialZoom: 10.0,
                            onTap: (_, position) {
                              // Update position on tap
                              locationController.updatePosition(position, widget.fromAddress);
                              setState(() {
                                _initialPosition = position; // Update the marker position
                              });
                            },
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
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _initialPosition, // Update marker position
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
                        Center(
                          child: !locationController.loading?Image.asset("assets/image/pick_marker.png",
                          height: 50,
                          width: 50,):CircularProgressIndicator(color: const Color.fromARGB(255, 187, 33, 243),),
                          

                        ),
                        Positioned(
                          top: Dimensions.height45,
                          height: Dimensions.height40+10,
                          right: Dimensions.width20,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.width10,
                            
                            ),
                          height: 45,
                          decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                          

                          ),
                          
                          child: Row(
                            children: [
                              Icon(Icons.location_on,size: 25,color: AppColors.yellowColor,),
                              Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
                                
                              
                                
                                child: Text(
                                  
                              
                                  '${locationController.placemark.name ?? ""}',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 73, 10, 10),
                                    fontSize: Dimensions.font16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                              ),
                            ],
                          )


)

                        ),
        Positioned(
  bottom: 200,
  left: Dimensions.width20,
  right: Dimensions.width20,
  child: locationController.isLoading 
    ? Center(child: CircularProgressIndicator()) 
    : CustomButton(
        buttonText: locationController.inZone
          ? (widget.fromAddress ? 'Pick Address' : 'Pick Location')
          : 'Service Not Available',
        onPressed: (locationController.buttonDisabled || locationController.loading) 
          ? null 
          : () async {
              if (locationController.pickPosition != null && locationController.pickPlacemark.name != null) {
                if (widget.fromAddress) {
                  print("Now we can click");
                  // Move the camera or handle address update logic here if needed
                }
                // Call method to set address data
                locationController.setAddData();
                
                // Save the picked position
                AddressModel _addressModel = AddressModel(
                  addressType: locationController.addressTypeList[locationController.addressTypeIndex],
                  contactPersonName: "",
                  contactPersonNumber: "",
                  address: locationController.pickPlacemark.name!,
                  lat: locationController.pickPosition!.latitude.toString(),
                  lon: locationController.pickPosition!.longitude.toString(),
                );

                await locationController.addAddress(_addressModel).then((response) {
                  if (response.isSuccess) {
                    Get.toNamed(RouteHelper.getInitial());
                    Get.snackbar("Address", "Added Successfully");
                  } else {
                    Get.snackbar("Address", "Couldn't Save Address");
                  }
                });
              } else {
                print("Pick position or placemark is not set");
              }
              Get.back();
            },
      ),
)






                      ],
                    ),
                  );
          }),
        ),
      ),
    );
  }

}
