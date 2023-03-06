// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC9HNSH4OqzNYcuwuuh_pRgsIFMY8qb7cs',
    appId: '1:487885792799:web:990a50c90c7ec56066572a',
    messagingSenderId: '487885792799',
    projectId: 'prodparammod',
    authDomain: 'prodparammod.firebaseapp.com',
    storageBucket: 'prodparammod.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJbUDuF8iTQj-ydOg4vpPMvw-EyAvsHMw',
    appId: '1:487885792799:android:dcab45692e28a2f666572a',
    messagingSenderId: '487885792799',
    projectId: 'prodparammod',
    storageBucket: 'prodparammod.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLaDlLogHKgns69eKdlmPzQMfxHEeafuY',
    appId: '1:487885792799:ios:50420af2672feb5966572a',
    messagingSenderId: '487885792799',
    projectId: 'prodparammod',
    storageBucket: 'prodparammod.appspot.com',
    iosClientId: '487885792799-slji2ltvh4lhdd3hh10pg9lo00aneq97.apps.googleusercontent.com',
    iosBundleId: 'com.example.projeto',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDLaDlLogHKgns69eKdlmPzQMfxHEeafuY',
    appId: '1:487885792799:ios:50420af2672feb5966572a',
    messagingSenderId: '487885792799',
    projectId: 'prodparammod',
    storageBucket: 'prodparammod.appspot.com',
    iosClientId: '487885792799-slji2ltvh4lhdd3hh10pg9lo00aneq97.apps.googleusercontent.com',
    iosBundleId: 'com.example.projeto',
  );
}