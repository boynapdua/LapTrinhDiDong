import "dart:io";
import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import "widget/login.dart";
import "widget/register.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid ?
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyA4qmfFHnEUTPjhpZvl1STG5phTWKFo4II',  // current_key
          appId: '1:105828343703:android:1fd209bc7c4547ce00eed2',  // mobilesdk_app_id
          messagingSenderId: '105828343703',  // project_number
          projectId: 'cocktail-2b5df'  // project_id
      )
  ) : await Firebase.initializeApp();

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      routes: {
        "/": (context) => MyRegister(),
        "/register": (context) => MyRegister(),
        "/login": (context) => MyLogin(),
        //"/content": (context) => MyContent(),
      },
    );
  }
}

