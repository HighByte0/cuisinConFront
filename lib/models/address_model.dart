import 'dart:convert';

class AddressModel {
  int? _id;
  late String _addressType;
  late String _contactPersonName;
  late String _contactPersonNumber;
  late String _address;
  late String _lat;
  late String _lon;


  AddressModel({
    int? id,
    required String addressType,
    required String contactPersonName,
    required String contactPersonNumber,
    required String address,
    required String lat,
    required String lon,
  })  
  {
    _id = id;
    _addressType = addressType;
    _contactPersonName = contactPersonName;
    _contactPersonNumber = contactPersonNumber;
    _address = address;
    _lat = lat;
    _lon = lon;
  } 

  // Getters
  int? get id => _id;
  String get addressType => _addressType;
  String get contactPersonName => _contactPersonName;
  String get contactPersonNumber => _contactPersonNumber;
  String get address => _address;
  String get lat => _lat;
  String get lon => _lon;

  // Factory constructor for creating a new AddressModel instance from a map
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
   
      contactPersonName: json['contact_person_name'],
      contactPersonNumber: json['contact_person_number'],
      address: json['address'],
      lat: json['latitude'],
      lon: json['longitude'],
      addressType: json['address_type'] ?? '',
      // delivery_address:json['delivery_address'],
    );
  }

  // Method for converting AddressModel instance to a map
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'address_type': _addressType,
      'contact_person_name': _contactPersonName,
      'contact_person_number': _contactPersonNumber,
      'address': _address,
      'latitude': _lat,
      'longitude': _lon,
    };
  }
}
  