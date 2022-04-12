# Device Risk iOS SDK

# Version: 1.1.0 - Release Date : April 11, 2022

The Socure Device Risk SDK provides a framework to identify the authenticity of phones and users of your mobile application.

This guide covers integration with iOS.
- **Minimum Requirements**: iOS 12 and above
- **Minimum IDE**: Xcode 11.4+

**Note**: If you are compiling an earlier verion of Xcode, please contact support.

## Introduction

The Device Risk SDK utilizes a number of data types to ascertain the authenticity of a device. These features are:

|      Data Type       |  Description                                                                                                                                                                              |
|:--------------------:| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Device-centered data | Data tied to information about linguistic, cultural, and technological conventions for use in formatting data for presentation (calendar type, keyboard language, etc.) |
|    Accessibility     | Active acessibility settings.                                                                                                                                                  |
|       Network        | WiFi connection information. Enable the Access WiFi Information service for your App ID, and include it in Entitlements.plist to access the information.                       |
|       Location       | Location and regional data.                                                                                                                                                    |
|    Device motion     | Device motion data, such as acceleration and gyroscope.                                                                                                                        |
|    Advertising ID    | Apple-issued ID that identifies a device to advertisers.                                                                                                                       |
|      Pedometer       | Pedometer data (steps, floors, etc.).                                                                                                                                          |

For the most part, Device Risk will only leverage the device features and services already used by your app. Device Risk will **only** track the devices features you specify during the initialization process.

In order to minimize reinitialization of existing services, the DeviceRisk framework expects that you, as the end developer, will provide the data expected for the features and services DeviceRisk was initialized and tasked to track. If said data is not provided to the SDK before the data is ready to be transmitted, the SDK will attempt to gather the data on its own. **This may mean that the SDK itself will attempt to request permissions for services out of order from your intended flow**

With that in mind, it is important to note that for certain services and features, your app must be appropriately configured. For example:

- To request WiFi data, your app must activate the `Access WiFi Information` capability. This is an additional capability you can add via the “Signing and Capabilities” section of your Project Target.
- For Advertising information support, you need to add `NSUserTrackingUsageDescription` key to your app’s Info.plist
- To use device motion (which includes accelerometer, gyroscope and device motion support), you need to configure the `UIRequiredDeviceCapabilities` key of your app’s Info.plist file with the accelerometer and gyroscope values.
- To use pedometer data, you need to add `NSMotionUsageDescription` key to your app’s Info.plist
- For location data, you need to include the appropriate location request key in your Info.plist. By default, the SDK expects the `NSLocationWhenInUseUsageDescription` key to be present in your Info.plist.

Please note: if you initialize the SDK with a specific service or feature to use, and you do not provide it with the service’s appropriate data before transmitting it to us, the SDK **will do a best effort to compile the data on its own. If the aforementioned configurations are not in place for a tracked feature, your app will crash**

## Installation

**Step 1: Install Socure SDK using CocoaPods (Recommended)**

The SDK can be added to the project by adding the following to your Podfile:

```
use_frameworks!

  # Pods for Device Risk
    pod 'DeviceRisk', :git => 'git@github.com:socure-inc/socure-sigmadevice-sdk-ios.git'
```
_Note: The DeviceRisk repo’s location is temporary at this time._

**Step 2: Add appropriate permissions for the services you want DeviceRisk SDK to use**

This is explained in more detail in the [Introduction](#Introduction)

**Step 3: Import the SDK into your desired View Controller**

Call `import DeviceRisk` at the top of your View Controller.

**Step 4: Implement Extension**

The DeviceRisk SDK uses the `DataUploadCallback` protocol to provide feedback on the results of the `sendData` function. There are two protocols that needs to be implemented
* `dataUploadFinished(uploadResult: UploadResult) `. This is returned when `sendData` has no complications. `UploadResult` is an object class that, at this time, returns the UUID computed by our services.
* `onError(errorType: SocureSDKErrorType, errorMessage: String)`. This is returned when `sendData` encounters an error. We provide the error type via `errorType` and a message via `errorMessage`.

## Caution

Given Apple's stringent nature in protecting device privacy, and the fact that the DeviceRisk SDK implements and can use (if directed to by you, the end developer) Location information (aka Core Location), Device motion data (aka Core Motion) and network connectivity information, we've been made aware that all apps published through the App Store **must** implement the following keys in their Info.plist:

- `NSMotionUsageDescription`
- `NSLocationWhenInUseUsageDescription`

While none of these functionalities will be called forth by DeviceRisk **unless** specified in `setTracker`, Apple's review process has flagged these key values as necessary, otherwise Apple will either a) inform you of the missing key needed in Info.plist or b) quietly remove the uploaded build without any notice, and before it's approved.

### Migration

If you're migrating from another repo, you need to update your Podfile to the following: 

```
use_frameworks!

  # Pods for Device Risk
    pod 'DeviceRisk', :git => 'git@github.com:socure-inc/socure-sigmadevice-sdk-ios.git'
```

After which, run `pod update` to update your project with the latest source code. 

## Usage

### Set-up and configuration

The DeviceRisk SDK’s main class available to end-developers is `DeviceRiskManager`. You can either initialize a local instance of `DeviceRiskManager` via:

```
public init()
```

Or, you can use a global, shared instance of `DeviceRiskManager` by calling:

```
DeviceRiskManager.sharedInstance
```

In either case, your next step is to configure `DeviceRiskManager` . You do this by calling `setTracker`.

### setTracker

```
setTracker(key:String, sources:[DeviceRiskDataSources], existingUUID:String, userConsent:Bool)
```

Where:
- `key` input parameter is your SDK key procured from the Socure admin dashboard.
- `userConsent` parameter must be set to true or data will not be processed by Socure

    > **Note**: We recommend using a single Production API key for all API requests that call the Device Risk module *only*. Be sure to use the SDK key for that account when running the data collection code on *all* of your pages. To generate the API and SDK keys, create an account for Device Risk only calls on the Admin Dashboard.

- `DeviceRiskDataSources` is an enum that encompasses all of the different device features and services we support.
- The function `setTracker` is expecting an array of `DeviceRiskDataSources` to determine which data from which services to expect.

These are:

### DeviceRiskDataSources

Device Risk depends on data from a device to gauge the authenticity of that device. While we recognize there are circumstances in which not all data types are available, we encourage you to gather as much data as possible.

The data type `location` is strongly recommended. We also recommend, at a minimum:

- `device`
- `locale`
- `accessibility`
- `network`

Please note, any data type specified that is not included, the SDK will attempt to obtain. The optimal list of data types are:

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
```

If you wanted to track all services possible, for example, you would call `setTracker` as so:

```
DeviceRiskManager.sharedInstance.setTracker(key: "<SOCURE_Public_Key>", sources:  [.device, .network, .accessibility, .locale, .advertising, .accelerometer,.magnetometer,.motion, .pedometer, .location])
```

Please note: `DeviceRiskManager` expects a [DataUploadCallback](#DataUploadCallback) delegate to be set. You are able to do this through the `delegate` variable of `DeviceRiskManager`

**Note**: The `existingUUID` parameter is a unique identifier previously calculated by the DeviceRisk SDK at a previous instance. Please pass that UUID here so historical data of the tracked device is preserved to one unique identifier. As for `userConsent`, we expect that you will obtain the user's consent for maintaining a historical record of their tracked data. If the user rejects that consent, pass a `false` value here (or via the `userConsentProvided` variable) and DeviceRisk will not keep a history of the UUID's submitted values (i.e., only the latest one is maintained).

### Provide data to SDK

There are certain iOS device features like Location retrieval, device motion retrieval and pedometer data where running multiple instances of these services is battery-intensive and not recommended. To that end, we have created a number of functions for you to use to provide the SDK with the expected necessary data.

Note: these calls must be called **after** [setTracker](#setTracker), but **before** [sendData](#sendData) is called.

> Warning: Run `sendData` BEFORE making an API call to ID+. This ensures ID+ has the most current up-to-date device data for that device.


These are:

### passMotionData

```
public func passMotionData(accelerometerData:CMAccelerometerData?, magnetometerData:CMMagnetometerData?, deviceMotionData:CMDeviceMotion)
```

`passMotionData`  accepts:
- Accelerometer data via a `CMAccelerometerData` object
- Magnetometer data via a `CMMagnetometerData` object
- Device motion data via a `CMDeviceMotion` object

Note: only `deviceMotionData` is required.

### passPedometerData

```
public func passPedometerData(pedometerData:CMPedometerData)
```

` passPedometerData` accepts the pedometer data via a `CMPedometerData` object

###  passLocationData

```
public func  passLocationData(locationData:CLLocation)
```

` passLocationData ` accepts the location data via a `CLLocation` object

### sendData

`sendData` communicates with Socure’s back-end services, takes all of the information provided and calculates a `UUID` for your device. Please note: once successful, you can retrieve the calculated UUID from the `uuid` variable of type `DeviceRiskUploadResult` in the `DeviceRiskUploadCallback`. The `context` parameter helps Socure understand where, or under what circumstances, device data is collected. The context enums are described below:
	
|      Context       |      Description  |
|:--------------------:| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
|homepage | Your main or screen that loads when the application or website opens page|
|signup	| All account creation pages|
|login | All pages that serve as an entry or access point (e.g. login page)|
|profile| Account/profile change pages|
|password | All password-related pages (forgot, reset, and create new password pages)|
|transaction | Any transaction-related page (adds an item to a cart, completes a purchase, etc.)|
|checkout | The page on which a customer completes a purchase |

In cases where none of the above context values are applicable, you can use the `other` context, which takes a String argument for you to freely specify the current context.
For best results, we ask that you always provide the context value. Examples of `sendData` calls are:

```
DeviceRiskManager.sharedInstance.sendData(context: .homepage)
DeviceRiskManager.sharedInstance.sendData(context: .signup)
DeviceRiskManager.sharedInstance.sendData(context: .other("custom context"))
```
Please note: to get the UUID, as well as the end status of `sendData`, you need to implement:

### DataUploadCallback

`DataUploadCallback` is a protocol object that implements two main functions.

* `dataUploadFinished(uploadResult: UploadResult) `. This is returned when `sendData` has no complications. `UploadResult` is an object class that, at this time, returns the UUID  computed by our services.
* `onError(errorType: SocureSDKErrorType, errorMessage: String)`. This is returned when `sendData` encounters an error. We provide the error type via `errorType` and a message via `errorMessage`.

## Device Validation

If you'd like to implement a device validation call using our ID Plus services from within your app, you would need to implement the appropriate network call to our `EmailAuthScore` endpoint. This call requires two parameters:

- `modules`, which is an array object, of which you **MUST** include `devicerisk` as one of the objects inside of the array in order to use Socure's Device Risk services
- `deviceSessionId`, which uses the `UUID` calculated by `DeviceRiskManager`

An example usage made with AlamoFire is provided in our `Demo` application, through the `Webcalls.swift` Swift file.
