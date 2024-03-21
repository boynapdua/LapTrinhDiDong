import "dart:io";
import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/services.dart";
import "package:laptrinhuddd/pages/home_page.dart";
import "package:laptrinhuddd/widgets/search.dart";
import "widget/login.dart";
import "widget/register.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid ?
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyBXhtj4Nq09eIqZy9gG5yhh6PkmlyDq1-Q',  // current_key
          appId: '1:868429047830:android:56c81b363c9086be206d37',  // mobilesdk_app_id
          messagingSenderId: '868429047830',  // project_number
          projectId: 'cooktail-3909d'  // project_id
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
        "/": (context) => HomePage(),
        "/search": (context) => MySearch(),
        "/register": (context) => MyRegister(),
        "/login": (context) => MyLogin(),
        //"/content": (context) => MyContent(),vod
      },
    );
  }
}

