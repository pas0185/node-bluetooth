# Terms of Use
Use of this API is subject to the [Variable Terms of Use](http://variableinc.com/terms-use-license/).

About this Repo
==============
This repo contains the NODE Objective-C framework, along with a sample iOS project demonstrating basic NODE functionality.

Want to keep updated? Visit us at [http://variableinc.com/](http://variableinc.com/)

Quick Start
==============
Using CocoaPods:
	
	pod try Node

Compatible Devices
==============
This framework is compatible with any Apple iOS product that is BlueTooth 4.0 low energy enabled. These devices include:

* Apple iPhone 4s and newer
* Apple iPad 3rd Generation and newer

This framework also has beta support for Mac OSX devices with Bluetooth Low Energy.

# Cocoapods Support
The preferred way to use our API is with [CocoaPods](http://www.cocoapods.org/). The NODE+ API is published under the **Node** pod. There is also a helper class that eliminates most CoreBluetooth boilerplate code published under the pod **NodeConnectionHelper**. 

# Getting Started
To get started quickly on iOS, see our [Getting Started Guide](https://bitbucket.org/variabletech/libnode-ios-public/downloads/NODE-iOS-SDK-Getting-Started.pdf).

## Getting Started Screencast
You can find a screencast to help you get up and running quickly [here](https://www.youtube.com/watch?v=mbVSYdV3Jo0).

# Documentation
The most reliable source for documentation of the API is through the header files included with the framework.
The documentation of our API is also hosted on [Cocoadocs](http://cocoadocs.org/docsets/Node), but is sometimes not up to date.

Required Frameworks
============
In order to compile successfully, your application needs to link against the following frameworks:

* CoreBluetooth.framework
* CoreLocation.framework
* libz.dylib
* libsqlite3.dylib
* GLkit.framework
* Accelerate.framework
* SystemConfiguration.framework

iOS Simulator
=============
Apple removed BTLE support for the iOS simulator as of iOS7.

Node Mac Framework
=============
When creating a Mac OSX project using our framework, you must add a *Copy Files* phase to your build project, and set it up like this:
![add_copy_phase](http://variabletech.bitbucket.org/add_copy_phase.png)

Revision Notes
=============
### 4.2.3
* Adds simulator architectures to framework

### 4.2.2 
* Combines releases and api demo repos

### Version 4.2.1
* Fixes code signing issues

### Version 4.1.0
* Release for iOS 8

### Version 4.0.1
* Removes Google analytics
* Add support for Chroma 2.0

### Version 3.5
* IMPORTANT: This release requires firmware release v21.16 for NODE2 devices
* Adds device-level time stamping support for Clima and Therma data
* Adds device-level time stamping support for motion data
* Fixes issues with proper scaling for ACC/Gyro values
* Adds support for motion event logging
* Adds ability to put NODE into radio silent mode
* Replaces space with underscrore in framework name (requires update of #import statements)

### Version 3.4
* Fixes bug in quaternion data ordering

### Version 3.3 
* OXA Support updated for connection to both ModA & B
* IO Module support added

### Version 3.2
* Minor bugfixes

### Version 3.1
* Upgrade for iOS 7
* Adds ability to set BLE connection paramaters

### Version 3.0 
* Updated for Node revision 2 devices

### Version 2.4 
* Update for Chroma 1.1 Production Support (color optimization for Chroma), whitepoint calibration, and Chroma temperature

### Version 2.31 
* Minor update that adds ability to rename and reboot device

### Version 2.3
* API updated for data logging (Clima only - other data streams coming soon)
* The library is now distributed as a framework 
** Your #import "libNode.h" statements will need to be changed to #import <Node/Node.h> 

### Version 2.2
* Library updated
* Fixed bug in demo app that caused Node to not always stream Kore data after connecting

### Version 2.1
* Library headers have been split into multiple files.

### Version 2.0 
* Rewrite (simplification) of library. All connection management and device discovery has been removed.
See the included demo project for an example of how to use.

### Version 1.2
* Adds ability to see devices connected to by other apps

### Version 1.1
* Now compatible with iOS 6

### Version 1.0
* Changed data format of VTSensorReadings from INT_16 to float. All readings are now given in standard units.

### Version 0.9
* Added ability to control on-board LEDs
* Added VERA module capability
* Added OXA module capability

### Version: 0.8
* Initial public release of libNode iOS.

Copyright (c) 2011-2012, Variable Technologies
All rights reserved.