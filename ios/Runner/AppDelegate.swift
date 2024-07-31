import UIKit
import Flutter
import NetworkExtension

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "wifi_configuration",
                                              binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "configureWifi" {
        if let args = call.arguments as? [String: Any],
           let ssid = args["ssid"] as? String,
           let passphrase = args["passphrase"] as? String {
          self.configureWifi(ssid: ssid, passphrase: passphrase, result: result)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func configureWifi(ssid: String, passphrase: String, result: @escaping FlutterResult) {
    let configuration = NEHotspotConfiguration.init(ssidPrefix: ssid, passphrase: passphrase, isWEP: false)
    configuration.joinOnce = true

    NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
      if let error = error {
        if (error as NSError).code == NEHotspotConfigurationError.alreadyAssociated.rawValue {
          result(true)
        } else {
          result(FlutterError(code: "CONFIGURATION_ERROR", message: error.localizedDescription, details: nil))
        }
      } else {
        result(true)
      }
    }
  }
}
