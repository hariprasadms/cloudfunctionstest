import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyA_6hFi_ujaPVNaZrJT_-pLlYNrgM43w0Q",
            authDomain: "cloud-functions-testing-337a9.firebaseapp.com",
            projectId: "cloud-functions-testing-337a9",
            storageBucket: "cloud-functions-testing-337a9.appspot.com",
            messagingSenderId: "111609387497",
            appId: "1:111609387497:web:cf52484adaff09ab191378"));
  } else {
    await Firebase.initializeApp();
  }
}
