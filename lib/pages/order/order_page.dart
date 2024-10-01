import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/base/custom_app_bar.dart';
import 'package:food_delivery_flutter/controllers/order_controller.dart';
import 'package:food_delivery_flutter/pages/order/view_order.dart';
import 'package:get/get.dart';


class OrderPageApp extends StatelessWidget {
  const OrderPageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const OrderPage(),
    );
  }
}

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  TabController? _tabController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize TabController with a delay to simulate async setup
    Future.delayed(Duration.zero, () {
      setState(() {
        Get.find<OrderController>().getOrderList();
        _tabController = TabController(length: 2, vsync: this);
        _isInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        bottom: _isInitialized
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Current"),
                  Tab(text: "History"),
                ],
              )
            : null,
      ),
      body: _isInitialized
          ? TabBarView(
              controller: _tabController,
              children: const <Widget>[
                ViewOrder(isCurrent: true),
                ViewOrder(isCurrent: false),
              ],
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Loading Orders..."),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            ),
    );
  }
}
