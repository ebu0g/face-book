import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signup.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  User? _initialUser;
  StreamSubscription<User?>? _authSub;

  @override
  void initState() {
    super.initState();
    _initialUser = FirebaseAuth.instance.currentUser;
    final opts = FirebaseAuth.instance.app.options;
    debugPrint('Auth project=${opts.projectId} appId=${opts.appId}');
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      // Only navigate if a new sign-in happened after this page was opened.
      final isNewSignIn = user != null &&
          (_initialUser == null || user.uid != _initialUser!.uid);
      if (isNewSignIn) {
        try {
          final userDoc =
              FirebaseFirestore.instance.collection('users').doc(user.uid);
          final snap = await userDoc.get();
          if (!snap.exists) {
            await userDoc.set({
              'first_name': user.displayName?.split(' ').first ?? '',
              'last_name': user.displayName?.split(' ').skip(1).join(' ') ?? '',
              'email': user.email ?? '',
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
        } catch (e) {
          // Ignore Firestore errors; do not block navigation.
        }
        if (!mounted) return;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showSnack(const Text('Please enter email and password'));
      return;
    }
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      debugPrint(
          'FirebaseAuthException (login): code=${e.code} message=${e.message}');
      if (e.code == 'user-not-found') {
        _showSnack(const Text('No user found for that email. Please sign up.'));
        _navigateToSignup();
      } else if (e.code == 'wrong-password') {
        _showSnack(const Text(
            'Wrong email or password. If you signed up with Google, use "Continue with Google".'));
        await _promptGoogleInstead();
      } else if (e.code == 'invalid-credential') {
        _showSnack(const Text(
            'Wrong email or password. If you signed up with Google, use "Continue with Google".'));
        await _promptGoogleInstead();
      } else if (e.code == 'invalid-email') {
        _showSnack(const Text('Invalid email format.'));
      } else if (e.code == 'operation-not-allowed') {
        _showSnack(const Text('Email/Password sign-in disabled.'));
      } else {
        _showSnack(const Text('Login failed. Please try again.'));
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showSnack(Widget content) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content));
  }

  void _navigateToSignup() {
    if (!mounted) return;
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const SignupPage()));
  }

  Future<void> _sendPasswordReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnack(const Text('Enter your email first.'));
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnack(
          const Text('If an account exists, a reset email has been sent.'));
    } catch (e) {
      _showSnack(const Text('Failed to send reset email. Please try again.'));
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider()
          ..setCustomParameters({'prompt': 'select_account'});
        await FirebaseAuth.instance.signInWithRedirect(provider);
        return; // Navigation happens via authStateChanges listener.
      }

      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Google sign-in failed: $e')));
    }
  }

  Future<void> _promptGoogleInstead() async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Try Google sign-in?'),
          content: const Text(
              'It looks like this account may be Google-based. Continue with Google to sign in.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await _handleGoogleSignIn(context);
              },
              child: const Text('Continue with Google'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 219, 219),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'facebook',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 400,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Login to facebook',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _loading ? null : _login,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          _loading ? 'Logging in...' : 'Log In',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed:
                          _loading ? null : () => _handleGoogleSignIn(context),
                      child: const Text(
                        'Continue with Google',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _loading ? null : _sendPasswordReset,
                      child: const Text(
                        'Forgotten Password?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '------------------OR------------------',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()),
                        );
                      },
                      child: const Text(
                        'Create New Account',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
