## Prerequisites
- [Flutter SDK (Latest Stable)](https://docs.flutter.dev/get-started/install)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development on macOS)
- CocoaPods version 1.16.2
- [Android Studio](https://developer.android.com/studio) (for Android development) with latest Flutter plugin installed
- Android SDK (Latest)
- Java version 21
- [VS Code](https://code.visualstudio.com/) or [IntelliJ IDEA](https://www.jetbrains.com/idea/#) with latest Flutter plugin installed
- Internet connection

# How to run
## Step 1: Open the project
Download the project and open it in VS Code or IntelliJ IDEA
## Step 2: Ensure the Latest Flutter SDK installed
To use the latest Stable Flutter SDK, in terminal run
```
flutter channel stable
flutter upgrade
```
To check if the latest Flutter SDK is installed, in terminal run
```
flutter doctor -v
```
The result should more or less look like this
```
[✓] Flutter (Channel stable, 3.32.5, on macOS 15.2 24C101 darwin-arm64, locale en-ID)  
• Flutter version 3.32.5 on channel stable at [Flutter SDK path]  
• Upstream repository https://github.com/flutter/flutter.git  
• Framework revision fcf2c11572 (6 days ago), 2025-06-24 11:44:07 -0700  
• Engine revision dd93de6fb1  
• Dart version 3.8.1  
• DevTools version 2.45.1

[✓] Android toolchain - develop for Android devices (Android SDK version 35.0.1)  
• Android SDK at [Android SDK path]  
• Platform android-35, build-tools 35.0.1  
• Java binary at: [Java JDK path]  
This is the JDK bundled with the latest Android Studio installation on this machine.  
To manually set the JDK path, use: `flutter config --jdk-dir="path/to/jdk"`.
• Java version OpenJDK Runtime Environment (build 21.0.6+-13391695-b895.109)  
• All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 16.2) [16.8s]
• Xcode at /Applications/Xcode.app/Contents/Developer
• Build 16C5032a
• CocoaPods version 1.16.2

[✓] Chrome - develop for the web [123ms]
• Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2025.1) [123ms]
• Android Studio at /Users/appkey-01/Applications/Android Studio.app/Contents
• Flutter plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/9212-flutter
• Dart plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/6351-dart
• Java version OpenJDK Runtime Environment (build 21.0.6+-13391695-b895.109)

[✓] IntelliJ IDEA Community Edition (version 2025.1.2) [121ms]
• IntelliJ at /Users/appkey-01/Applications/IntelliJ IDEA Community Edition.app
• Flutter plugin version 86.0.2
• Dart plugin version 251.25410.28

[✓] VS Code (version 1.92.1) [16ms]
• VS Code at /Applications/Visual Studio Code.app/Contents
• Flutter extension version 3.94.0

[✓] Connected device (2 available)
• sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64  • Android 14 (API 34) (emulator)
• Chrome (web)                • chrome        • web-javascript • Google Chrome 137.0.7151.122

[✓] Network resources [474ms]
• All expected network resources are available.
```
## Step 3: Get dependencies
After the Latest Stable Flutter SDK installed, in the terminal of root project run
```
flutter pub get
```
## Step 4: Selecting device
Before running the project, select an Android or iOS device. In the terminal of root project run
```
flutter devices
flutter run -d <device-id>
```
## Step 5: Run the project

- **Android**  
  After selecting an Android device, run ```flutter run``` in the terminal of root project.

- **iOS**  
  Before running the project in iOS device, make sure `CocoaPods` version `1.16.2` is installed. To check it, in the ios directory of the project run
  ```
  pod --version
  ```
  to update the current `CocoaPods` run
  ```
  sudo gem update cocoapods
  ```
  or install the `Cocoapods`version `1.16.2`, run
  ```
  sudo gem uninstall cocoapods
  sudo gem install cocoapods -v 1.16.2
  ```
  After `CocoaPods` version `1.16.2` installed run `pod install` in the ios directory of the project.
  Or from the root project terminal run
  ```
  cd ios 
  pod install
  ```
  After pod is configured, run ```flutter run``` in the terminal of root project.
