// Firebase options for LOCAL EMULATOR (development).
// For production: run `flutterfire configure` to overwrite with real credentials.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Unsupported: $defaultTargetPlatform');
    }
  }

  // Emulator-safe placeholder values (any non-empty string works with emulator)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'emulator-api-key',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'meshilog-dev',
    storageBucket: 'meshilog-dev.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'emulator-api-key',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'meshilog-dev',
    storageBucket: 'meshilog-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'emulator-api-key',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'meshilog-dev',
    storageBucket: 'meshilog-dev.appspot.com',
    iosBundleId: 'com.example.meshilog',
  );
}
