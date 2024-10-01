import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NearFood extends StatefulWidget {
  const NearFood({super.key});

  @override
  State<NearFood> createState() => _NearFoodState();
}

class _NearFoodState extends State<NearFood> {
  LatLng? _initialPosition;
  List<LatLng> foodLocations = [];
  List<int> listTypeId = []; // Use List<int> instead of List<Int>

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchFoodLocations(); // Fetch food locations from API
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _fetchFoodLocations() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.141.113:8000/api/v1/products/recommended'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> products = data['products'];

        for (var item in products) {
          // Handle lat and lon as double and check type_id as int
          double lat = double.parse(item['lat']); // latitude
          double lon = double.parse(item['lon']); // longitude
          int typeId = item['type_id']; // type_id is an int

          foodLocations.add(LatLng(lat, lon));
          listTypeId.add(typeId); // Add typeId to listTypeId

          // Debug output to verify the values being added
          print('Added location: ($lat, $lon) with type_id: $typeId');
        }

        setState(() {}); // Update UI after fetching locations
      } else {
        throw Exception('Failed to load food locations');
      }
    } catch (e) {
      print("Error fetching food locations: $e");
    }
  }

  List<LatLng> _getNearbyFoodLocations() {
    if (_initialPosition == null) return [];

    return foodLocations.where((location) {
      double distanceInMeters = Geolocator.distanceBetween(
        _initialPosition!.latitude,
        _initialPosition!.longitude,
        location.latitude,
        location.longitude,
      );
      return distanceInMeters <= 10000; // Within 10,000 meters
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Food')),
      body: _initialPosition == null
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter: _initialPosition!,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _initialPosition!,
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.person_2_rounded,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                    // Add markers for nearby food locations
                    ..._getNearbyFoodLocations().asMap().entries.map((entry) {
                      LatLng location = entry.value;
                      int index = entry.key;
                      return Marker(
                        point: location,
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          onTap: () {
                            if (listTypeId == 3) {
                               Get.offNamed(RouteHelper.getRecommendedFoodDetail(index, "initial"));
        
        } else {
           Get.offNamed(RouteHelper.getPopularFoodDetail(index, "initial"));
        }
      
                          },
                          child: const Icon(
                            Icons.food_bank_rounded,
                            color: Colors.green,
                            size: 40,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
    );
  }
}
