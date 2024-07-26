import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/login.dart';
import 'package:flutter_application_1/auth/signup%20.dart';
import 'package:flutter_application_1/home/homepage.dart';
import 'package:flutter_application_1/query/addnotes.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'dart:html';
late bool islogin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    islogin = false;
  } else {
    islogin = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Color.fromARGB(255, 243, 208, 51),
        textTheme: const TextTheme(
            headlineSmall:
                TextStyle(fontSize: 20, color: Color.fromARGB(255, 58, 56, 56)),
            bodyMedium: TextStyle(fontSize: 30, color: Colors.black)),
      ),
      home: islogin == false ? const Login() : const HomePage(),
      routes: {
        "login": (context) => const Login(),
        "signup": (context) => const Signup(),
        "HomePage": (context) => const HomePage(),
        "addnotes": (context) => const AddNotes(),
      },
    );
  }
}
// > Manifest merger failed : uses-sdk:minSdkVersion 16 cannot be smaller than version 19 declared in library
// firebase_core" is already in "dependencies". Use "pub upgrade firebase_core" to upgrade to a later version!
// jiffy: ^4.0.0
//   image_picker: ^0.7.2
//   http: ^0.13.0
//   shared_preferences: ^2.0.3
//   firebase_core: ^1.0.1
//   firebase_storage: ^8.0.0
//   cloud_firestore: ^1.0.1
//   firebase_messaging: ^9.0.0
//   firebase_auth: ^1.0.1
//   awesome_dialog: ^1.3.1
//   dropdown_search: ^0.4.8