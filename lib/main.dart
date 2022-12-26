import 'package:chat_app_course/auth/auth_provider.dart';
import 'package:chat_app_course/auth/sign_in_screen.dart';
import 'package:chat_app_course/auth/sign_up_screen.dart';
import 'package:chat_app_course/const/const.dart';
import 'package:chat_app_course/screens/chat_screen.dart';
import 'package:chat_app_course/screens/contact_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance ;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await messaging.getToken().then((value) {
    fcmToken = value;
    // print(fcmToken);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider())
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(

            primarySwatch: Colors.blue,

          ),
          routes: {
            ChatScreen.routeName : (ctx) => ChatScreen(),
            LoginScreen.routeName : (ctx) => LoginScreen(),
            SignUpScreen.routeName : (ctx) => SignUpScreen(),
            ContactScreen.routeName : (ctx) => ContactScreen(),
          },
          home: StreamBuilder(stream: FirebaseAuth.instance
              .idTokenChanges(), builder: (BuildContext context, AsyncSnapshot<User?> user) {
            if (user.data == null) {
              print('User is currently signed out!');
              return LoginScreen();
            } else {
              print('User is signed in!');
              Provider.of<AuthProvider>(context,listen: false).getData();
              return ContactScreen();
            }
          },)
      ),
    );
  }
}

