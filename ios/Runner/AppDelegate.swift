import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let _channelName = "com.itheamc.varosa_multi_app/native_channel"
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Registering Native Button View Factory
    let registrar = self.registrar(forPlugin: "native-button")!
    let factory = NativeButtonFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "native-button")
    
    // Creating Method Channel and Setting Method Call Handler
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: _channelName, binaryMessenger: controller.binaryMessenger)
    
    methodChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        if call.method == "getDeviceInfo" {
            
            UIDevice.current.isBatteryMonitoringEnabled = true
            
            let batteryLevel = UIDevice.current.batteryLevel
            let batteryPercent = Int(batteryLevel * 100)
            
            let deviceModel = UIDevice.current.model
            let systemTime = ISO8601DateFormatter().string(from: Date())
            
            let batteryState = UIDevice.current.batteryState
            let isCharging = batteryState == .charging || batteryState == .full
            
            let deviceInfo: [String: Any] = [
                "batteryLevel": batteryPercent,
                "deviceModel": deviceModel,
                "isCharging": isCharging,
                "systemTime": systemTime
            ]
            
            result(deviceInfo)
            
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
