# Sigma Device iOS SDK

The Sigma Device iOS SDK provides a framework for adding device fingerprinting into your native iOS applications.

## Minimum requirements

-   iOS 12 and above
-   Xcode 11.4+

## Installation

You can install the Sigma Device iOS SDK using CocoaPods or by manually downloading and installing it. We recommend that you use CocoaPods.

To install the SDK using CocoaPods, add the following lines to your Podfile:

```
use_frameworks!

# Pods for Sigma Device

pod 'DeviceRisk', :git => 'socure-inc/socure-sigmadevice-sdk-ios.git'
```

After this, you'll need to import the SDK into your desired View Controller by calling `import DeviceRisk` at the top of your View Controller.

## Configuration and usage

The Sigma Device iOS SDK's main class is `DeviceRiskManager`. You can initialize a local instance of `DeviceRiskManager` via `public init()` or you can use a global, shared instance by calling `DeviceRiskManager.sharedInstance`.

### Configure the `DeviceRiskManager` Class

The SDK uses the following functions to collect device data and send it to Socure:

-  [setTracker()](#settracker)
-  [sendData()](#senddata)

### setTracker()

The `setTracker()` function configures the SDK and specifies the types of device data to collect and track.

To call `setTracker()`:

```
DeviceRiskManager.sharedInstance.setTracker(key:String, sources:[DeviceRiskDataSources], existingUUID:String, userConsent:Bool)
```

| Data types     | Description                                                                                                                                                    |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `key`          | The public SDK key for your account.                                                                                                                           |
| `sources`      | An array of `DeviceRiskDataSources` that identifies the types of device data to collect.                                                                       |
| `existingUUID` | The `deviceSessionId` calculated by the DeviceRisk SDK at a previous instance. Allows historical data for a device to be linked to a single unique identifier. |
| `userConsent`  | Indicates if the consumer has provided consent. If set to `false`, the SDK will not collect any device information.                                            |

#### DeviceRiskDataSources

Sigma Device depends on the following types of data to gauge the authenticity of a device:

| Data Type           | Description                                                                                                                                                           | Notes                                                                                                                                                                                                   |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Device-centric data | Data tied to information about linguistic, cultural, and technological conventions used to format data for presentation, such as calendar type and keyboard language. |                                                                                                                                                                                                         |
| Accessibility       | Active accessibility settings.                                                                                                                                        |                                                                                                                                                                                                         |
| Network             | WiFi connection information. Enable the Access WiFi Information service for your App ID and include it in `Entitlements.plist` to access the information.             | To request WiFi data, your app must activate the `Access WiFi Information` capability. This is an additional capability you can add via the “Signing and Capabilities” section of your Project Target.  |
| Location            | Location and regional data.                                                                                                                                           | To use location data, add the `NSLocationWhenInUseUsageDescription` key to `Info.plist`.                                                                                                                |
| Device motion       | Device motion data, such as acceleration and gyroscope.                                                                                                               | To use device motion data (includes accelerometer, gyroscope, and device motion support), configure the `UIRequiredDeviceCapabilities` key in `Info.plist` with the accelerometer and gyroscope values. |
| Advertising ID      | Apple-issued ID that identifies a device to advertisers.                                                                                                              | To use advertising information, add the `NSUserTrackingUsageDescription` key to `Info.plist`.                                                                                                           |
| Pedometer           | Pedometer data such as number of steps taken and floors climbed.                                                                                                      | To use pedometer data, add the `NSMotionUsageDescription` key to `Info.plist`.                                                                                                                          |

While there may be circumstances in which not all data types are available, we encourage you to gather as much data as possible. The data type `location` is strongly recommended. We also recommend, at a minimum:

-   `device`
-   `locale`
-   `accessibility`
-   `network`

The optimal list of data types are as follows:

```
case device
case accelerometer
case motion
case magnetometer
case locale
case location
case advertising
case pedometer
case network
case accessibility
case context
```

For example, to track all services, call `setTracker()` as follows:

```
`DeviceRiskManager.sharedInstance.setTracker(key: "<SOCURE_Public_Key>", sources: [.device, .network, .accessibility, .locale, .advertising, .accelerometer,.magnetometer,.motion, .pedometer, .location, .external])`
```

**Caution**: Apple requires that all apps published through the App Store implement the following keys in `Info.plist`:

```
`NSMotionUsageDescription`
`NSLocationWhenInUseUsageDescription`
```

Note that while these services will not be called by Sigma Device unless specified in `setTracker`, Apple's review process will flag these key values as required in `Info.plist`. If not included, Apple will either inform you of the missing keys, or remove the uploaded build before it's approved.

### sendData()

The `sendData()` function collects the device data, sends it to Socure’s servers, and returns a `deviceSessionId`.

To call `sendData()`:

```
DeviceRiskManager.sharedInstance.sendData(context:Context)
```

**Note**: To retrieve an existing `deviceSessionId` for a device, use the `uuid` variable of `DeviceRiskManager`.

### Context Parameter

The `context` parameter helps Socure understand where, or under what circumstances, device data is collected. The available `context` enums are described below:

| Context       | Description                                                                                     | Example                                                                       |
|---------------|-------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| `homepage`    | The main page that loads when the consumer opens an application.                                | `DeviceRiskManager.sharedInstance.sendData(context: .homepage)`               |
| `signup`      | Pages related to creating an account.                                                           | `DeviceRiskManager.sharedInstance.sendData(context: .signup)`                 |
| `login`       | Pages that serve as an entry or access point to an application, such as a login page.           | `DeviceRiskManager.sharedInstance.sendData(context: .login)`                  |
| `profile`     | Pages on which account or profile updates are completed.                                        | `DeviceRiskManager.sharedInstance.sendData(context: .profile)`                |
| `password`    | Pages related to password activities, such as resetting a password and creating a new password. | `DeviceRiskManager.sharedInstance.sendData(context: .password)`               |
| `transaction` | Pages related to transactions, such as adding an item to a cart and completing a purchase.      | `DeviceRiskManager.sharedInstance.sendData(context: .transaction)`            |
| `checkout`    | The page on which a consumer completes a purchase.                                              | `DeviceRiskManager.sharedInstance.sendData(context: .checkout)`               |
| `other`       | Allows you to pass a custom value for pages on which the above context values do not apply.     | `DeviceRiskManager.sharedInstance.sendData(context: .other("custom context")` |


#### DataUploadCallback

`DataUploadCallback` is an optional protocol object required by `DeviceRiskManager` that receives the status of `sendData()`. It implements two main functions:

| Function                                                       | Description                                                                                                                                                                         |
|----------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `dataUploadFinished(uploadResult: UploadResult)`               | The `dataUploadFinished()` function is returned when `sendData()` is successful. `UploadResult` is an object class that returns the device session `uuid` computed by our services. |
| `onError(errorType: SocureSDKErrorType, errorMessage: String)` | The `onError()` function is returned when `sendData()` encounters an error. We provide the error type via `errorType` and a message via `errorMessage`.                             |
