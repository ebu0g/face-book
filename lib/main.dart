import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'signup.dart';

void main() {
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
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
      },
      home: Scaffold(
        backgroundColor: const Color(0xFFE9EBEE), // light grey background
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
                color: Colors.blue, // make logo blue
              ),
              const SizedBox(height: 20),
              Builder(
                builder: (buttonContext) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // button color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
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
