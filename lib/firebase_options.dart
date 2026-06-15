import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => web;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAn_7yMeuqxwfR2HJ-jG93xqU2nxRgfkT4',
    appId: '1:601110560690:web:25af25de849d2b25282eab',
    messagingSenderId: '601110560690',
    projectId: 'homestock-8825d',
    authDomain: 'homestock-8825d.firebaseapp.com',
    storageBucket: 'homestock-8825d.firebasestorage.app',
    measurementId: 'G-6DG39J3314',
  );
}
