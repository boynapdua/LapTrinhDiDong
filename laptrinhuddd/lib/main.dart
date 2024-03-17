import "dart:io";
import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/services.dart";
import "package:laptrinhuddd/pages/home_page.dart";
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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: "/",
      routes: {
        "/": (context) => MyLogin(),
        "/register": (context) => MyRegister(),
        "/login": (context) => MyLogin(),
        //"/content": (context) => MyContent(),
      },
    );
  }
}

