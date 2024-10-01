import UIKit
import Flutter
import FireBase
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FireBaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Convert the device token to a string format for printing
    let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    
    // Set the APNs token for Firebase Messaging
    Messaging.messaging().apnsToken = deviceToken
    
    // Print the device token for debugging
    print("Device Token: \(tokenString)")
    
    // Call the superclass implementation if needed
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
}

}
