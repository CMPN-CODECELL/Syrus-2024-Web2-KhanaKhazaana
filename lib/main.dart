import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:syrus24/routes.dart';
import 'package:syrus24/screens/auth/signUpScreen.dart';
import 'package:syrus24/screens/home/exportHomeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('${snapshot.error}'),
                ),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                    Container(
                        height: 300,
                        child: Image.asset(
                          'assets/phone.png',
                          fit: BoxFit.contain,
                        ))
                  ],
                ),
              ),
            );
          }
          return SignUpScreen();
        },
      ),
      onGenerateRoute: (settings) => getRoutes(settings),
    );
  }
}
