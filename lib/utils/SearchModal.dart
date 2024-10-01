import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:get/get_connect.dart';

class SearchModal extends StatefulWidget {
  @override
  _SearchModalState createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _search(query);
    });
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    if (_isLoading) return; // Prevent simultaneous requests

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await GetConnect().get('http://192.168.33.93:8000/api/v1/products/popular');
      if (response.statusCode == 200) {
        List<dynamic> products = response.body['products'];
        setState(() {
          _searchResults = products
              .map((product) => Product.fromJson(product))
              .where((product) =>
                  product.name.toLowerCase().contains(query.toLowerCase()) ||
                  product.location.toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      height: MediaQuery.of(context).size.height * 0.5, // Adjust height as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigText(text: 'Search for Locations or Products', color: AppColors.mainColor),
          SizedBox(height: Dimensions.height20),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter a location or product title',
              prefixIcon: Icon(Icons.search, color: AppColors.mainColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height20),
          if (_isLoading)
            Center(child: CircularProgressIndicator())
          else if (_searchResults.isEmpty)
            Center(child: Text('No results found'))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  var product = _searchResults[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Location: ${product.location}'),
                    leading: product.img.isNotEmpty
                        ? Image.network(
                            product.img,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                              return Icon(Icons.error, color: Colors.red);
                            },
                          )
                        : Icon(Icons.image_not_supported, color: Colors.grey),
                    onTap: () {
                      print('Tapped on ${product.name}');
                      Navigator.of(context).pop(); // Close the modal
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stars;
  final String img;
  final String location;
  final String createdAt;
  final String updatedAt;
  final int typeId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stars,
    required this.img,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.typeId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      stars: json['stars'],
      img: json['img'],
      location: json['location'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      typeId: json['type_id'],
    );
  }
}
