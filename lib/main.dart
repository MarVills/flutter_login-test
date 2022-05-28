import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/social_auth/login_with_google.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //FirebaseFirestore.instance.settings = Settings(host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    name: "InitializeApp",
    options: FirebaseOptions(
      apiKey: "AIzaSyDzkZk-om5_M_8WiqRCauGjkxCJK3rayQk",
      appId: "1:835446078047:android:3dee0fb8c5b5e4603539ea",
      messagingSenderId: "835446078047",
      projectId: "loginauthentication-edc06",
      //androidClientId:"835446078047-voe7vfs1rqugcdora8djk8onsl89h3o4.apps.googleusercontent.com",
    ),

    //options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseApp defaultApp = Firebase.app("InitializeApp");
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
