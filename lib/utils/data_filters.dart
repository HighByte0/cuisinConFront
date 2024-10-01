import 'package:flutter/material.dart';
import 'package:data_filters/data_filters.dart';

class FilterExample extends StatefulWidget {
  @override
  _FilterExampleState createState() => _FilterExampleState();
}

class _FilterExampleState extends State<FilterExample> {
  // Original data in Map format
  List<Map<String, dynamic>> originalData = [
    {'id': 1, 'name': 'Product A', 'category': 'Category 1'},
    {'id': 2, 'name': 'Product B', 'category': 'Category 2'},
    {'id': 3, 'name': 'Product C', 'category': 'Category 1'},
    {'id': 4, 'name': 'Product D', 'category': 'Category 3'},
  ];

  // Convert data to List<List<dynamic>> format
  List<List<dynamic>> get data {
    // Group by categories and create the filter options
    var categories = originalData.map((item) => item['category']).toSet().toList();
    return categories.map((category) => [category]).toList();
  }

  List<String> titles = ['Category 1', 'Category 2', 'Category 3']; // Example filter titles
  List<int>? filterIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Filters Example'),
      ),
      body: DataFilters(
        data: data,
        filterTitle: titles,
        showAnimation: true,
        recent_selected_data_index: (List<int>? index) {
          setState(() {
            filterIndex = index;
          });
        },
        style: FilterStyle(
          buttonColor: Colors.green,
          buttonColorText: Colors.white,
        ),
      ),
    );
  }
}
