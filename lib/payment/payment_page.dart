import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/models/order_model.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel orderModel;
  PaymentScreen({required this.orderModel});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String selectedUrl;
  bool _canRedirect = true;
  bool _isLoading = true;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    selectedUrl = '${AppConstants.BASE_URL}/api/v1/payment-mobile?customer_id=${widget.orderModel.userId}&order_id=${widget.orderModel.id}';
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
            setState(() {
              _isLoading = true;
            });
            _redirect(url);
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            setState(() {
              _isLoading = false;
            });
            _redirect(url);
          },
          onHttpError: (HttpResponseError error) {
            print('HTTP error: ${error.response}');
          },
          onWebResourceError: (WebResourceError error) {
            print('Web resource error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(selectedUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Payment"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => _exitApp(context),
          ),
          backgroundColor: AppColors.mainColor,
        ),
        body: Center(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  void _redirect(String url) {
    print("redirect");
    if (_canRedirect) {
      bool _isSuccess = url.contains('success') && url.contains(AppConstants.BASE_URL);
      bool _isFailed = url.contains('fail') && url.contains(AppConstants.BASE_URL);
      bool _isCancel = url.contains('cancel') && url.contains(AppConstants.BASE_URL);
      if (_isSuccess || _isFailed || _isCancel) {
        _canRedirect = false;
      }
      if (_isSuccess) {
       Get.offNamed(RouteHelper.getOrderSuccessPage( 'success',widget.orderModel.id.toString(),));
      } else if (_isFailed || _isCancel) {
       Get.offNamed(RouteHelper.getOrderSuccessPage(widget.orderModel.id.toString(), 'fail'));
      } else {
        print("Encountered problem");
      }
    }
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      print("app exited");
      return true;
    }
  }
}
