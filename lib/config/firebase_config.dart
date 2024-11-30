import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyA9Y1WHDZE1xewyDRrNe8wO35cNiOsXgBA',
        appId: '1:354390537471:android:e6b1287ae222eb964c08ca',
        messagingSenderId: '354390537471',
        projectId: 'application-ddb7c',
      ),
    );
  }
}
