//
//  AppDelegate.swift
//  SampleApp
//
//  Copyright © 2025 Socure. All rights reserved.
//

import UIKit
import DeviceRisk

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let SDKKey = "Socure-public-key"
        let options = SigmaDeviceOptions(
            omitLocationData: false,
            advertisingID: nil,
            useSocureGov: false,
            configBaseUrl: nil)

        SigmaDevice.initializeSDK(SDKKey, options: options) { result, error in
            guard let error = error else {
                if let sessionToken = result {
                    print(sessionToken)
                }
                return
            }

            switch error {
            case .dataUploadError(let code, let message):
                print("\(code ?? ""): \(message ?? "")")
            case .networkConnectionError(let networkConnectionError):
                let nsError = networkConnectionError as NSError
                print("\(nsError.domain): \(nsError.code): \(nsError.localizedDescription)")
            case .dataFetchError:
                print(".dataFetchError")
            case .sdkNotInitializedError:
                print("The SDK is not initialzed!")
            case .sdkPausedError:
                print("The SDK is paused!")
            case .unknownError:
                fallthrough
            @unknown default:
                print("unknown error")
            }
        }

        return true
    }
}
