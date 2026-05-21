import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD24EM9DaYqaaNj8ipG_PX-sREBLpqvp0M',
    authDomain: 'fir-auth-firestore-app-4dc2f.firebaseapp.com',
    projectId: 'fir-auth-firestore-app-4dc2f',
    storageBucket: 'fir-auth-firestore-app-4dc2f.firebasestorage.app',
    messagingSenderId: '458632085027',
    appId: '1:458632085027:web:YOUR_WEB_APP_ID', // Get this from Firebase Console
    measurementId: 'G-XXXXXXXXXX', // Get this from Firebase Console (optional)
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD24EM9DaYqaaNj8ipG_PX-sREBLpqvp0M',
    appId: '1:458632085027:android:832b1612898c7fec84bb96',
    messagingSenderId: '458632085027',
    projectId: 'fir-auth-firestore-app-4dc2f',
    storageBucket: 'fir-auth-firestore-app-4dc2f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD24EM9DaYqaaNj8ipG_PX-sREBLpqvp0M',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '458632085027',
    projectId: 'fir-auth-firestore-app-4dc2f',
    storageBucket: 'fir-auth-firestore-app-4dc2f.firebasestorage.app',
    iosBundleId: 'com.example.firebaseAuthFirestoreApp',
  );

  static FirebaseOptions get currentPlatform {
    return web;
    // Uncomment below if supporting multiple platforms
    // if (kIsWeb) {
    //   return web;
    // }
    // switch (defaultTargetPlatform) {
    //   case TargetPlatform.android:
    //     return android;
    //   case TargetPlatform.iOS:
    //     return ios;
    //   default:
    //     throw UnsupportedError(
    //       'DefaultFirebaseOptions are not supported for this platform.',
    //     );
    // }
  }
}

