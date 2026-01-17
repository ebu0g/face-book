import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';
import 'login.dart';
import 'signup.dart';
import 'groups.dart';
import 'notifications.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/groups': (context) => const GroupsPage(),
        '/notifications': (context) => const NotificationsPage(),
      },
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
                color: Colors.blue,
              ),
              Builder(
                builder: (buttonContext) => ElevatedButton(
                  child: const Text('Start'),
                  onPressed: () {
                    Navigator.pushNamed(buttonContext, '/login');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
