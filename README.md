# GL Mobile Scanning App

A Flutter project to scan Ticketmaster barcodes containing event IDs and displaying event data.

## Demo

Screen recording demo available: `demo.webm`

## Setup

Make sure Flutter is installed on your machine and run `flutter doctor` to resolve any issues.

Install app dependencies:
```shell
cd app
flutter pub get
```

Analyze the app using `flutter analyze` if any errors occur.

Verify available devices to run the app:
```shell
flutter devices
```

It is recommended to setup an android emulator from the Android SDK 35 in Android Studio, and create a virtual device. You can also use the cmd tools to create or select an emulator using:
```shell
flutter emulators
```
In Android Studio, make sure your emulator uses an available video hardware such as a webcam to enable live scanning. Usually, the camera_back property should be set to `webcam0` for this to work. If you're using an actual android device, this step is not required.

Use the device or emulator of your choice, and run app from the `app/lib/main.dart` file in your IDE (VS Code, Android Studio) or run using:
```shell
flutter run "lib/main.dart" -d <your_device_id>
```

## Unit Tests

Run unit tests with:
```shell
flutter test
```

Upon adding `@GenerateMocks` annotations to test classes, generate given mock types using:
```shell
dart run build_runner build
```

## API Key

The initial API key has been voluntarily excluded from version control.
If you wish to test the app locally using your own API key,
you need to add a `secret.json` file to the repository (and potentially create the `/auth` directory):
```
/app/auth/secret.json
```

The app will expect this JSON structure to read the API key:
```
secret.json

{
    "api_key": "<your_api_key>"
}
```
