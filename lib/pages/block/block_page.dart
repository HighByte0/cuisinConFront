import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountBlockedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Blocked'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.block,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Your account has been blocked.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'If you believe this is a mistake, please contact support.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
           Text("Contact this Email : support@Cuisinconnectee.com"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Redirect to login page
                Get.offNamed('/login'); // Replace with your route
              },
              child: Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
