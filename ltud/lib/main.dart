import "dart:io";
import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import "package:ltud/widgets/Home.dart";
import "package:ltud/widgets/country.dart";
import "package:ltud/widgets/login.dart";
import "package:ltud/widgets/register.dart";

import "models/city.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid ?
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyD_DCWqJDkqKhkN7vz4GHFAasMJ4Fm62u8',  // current_key
          appId: '1:219459450874:android:e5a517448ecf2a34eb1643',  // mobilesdk_app_id
          messagingSenderId: '219459450874',  // project_number
          projectId: 'ltud-3f1c7'  // project_id
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
        //"/": (context) => MyRegister(),
        "/": (context) => HomePage(),
        //"/register": (context) => MyRegister(),
        //"/login": (context) => MyLogin(),
        // "/content": (context) => MyContent(),
      },
    );
  }
}



