import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA9O_NQL1gPb0BAI5UNIF87tP2KvGl0_fU',
    appId: '1:389689484411:web:50a5e6b38f32d7d453eede',
    messagingSenderId: '389689484411',
    projectId: 'habit-assig',
    authDomain: 'habit-assig.firebaseapp.com',
    storageBucket: 'habit-assig.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDL-K_HhqIZNYP_IgigjR-tt6x55HAvS_Y',
    appId: '1:389689484411:android:558bc4977f57671e53eede',
    messagingSenderId: '389689484411',
    projectId: 'habit-assig',
    storageBucket: 'habit-assig.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCrL5xHGeLgeTZbu9lzN3fOo4349RJXR5A',
    appId: '1:389689484411:ios:8f38a64eda1147d253eede',
    messagingSenderId: '389689484411',
    projectId: 'habit-assig',
    storageBucket: 'habit-assig.appspot.com',
    iosBundleId: 'com.example.habitOnAssig',
  );
}
