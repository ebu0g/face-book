import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'login.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? selectedValue1;
  String? selectedValue2;
  String? selectedValue3;
  String? gender;
  bool _loading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and Password are required")),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set(
        {
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'email': email,
          'birthday': {
            'month': selectedValue1,
            'day': selectedValue2,
            'year': selectedValue3,
          },
          'createdAt': FieldValue.serverTimestamp(),
        },
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'email-already-in-use') {
        message = 'The email is already in use';
      } else if (e.code == 'weak-password') {
        message = 'The password is too weak';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address';
      } else if (e.code == 'operation-not-allowed') {
        message = 'Email/Password sign-in is disabled in Firebase';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many attempts. Please try again later';
      }
      debugPrint(
          'FirebaseAuthException (signup): code=${e.code} message=${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      UserCredential cred;
      if (kIsWeb) {
        final provider = GoogleAuthProvider()
          ..setCustomParameters({'prompt': 'select_account'});
        await FirebaseAuth.instance.signInWithRedirect(provider);
        return; // Navigation happens via authStateChanges listener.
      } else {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) return;
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        cred = await FirebaseAuth.instance.signInWithCredential(credential);
      }
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(cred.user!.uid);
      final snap = await userDoc.get();
      if (!snap.exists) {
        await userDoc.set({
          'first_name': cred.user?.displayName?.split(' ').first ?? '',
          'last_name':
              cred.user?.displayName?.split(' ').skip(1).join(' ') ?? '',
          'email': cred.user?.email ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EBEE),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Create New Account',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'It\'s quick and easy.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              hintStyle:
                                  const TextStyle(color: Color(0xFFB1ADAD)),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              hintStyle:
                                  const TextStyle(color: Color(0xFFB1ADAD)),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '   Birthday',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: _CustomDropDown(
                            items: const [
                              'Jan',
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun',
                              'Jul',
                              'Aug',
                              'Sep',
                              'Oct',
                              'Nov',
                              'Dec'
                            ],
                            hint: 'Month',
                            value: selectedValue1,
                            onChanged: (val) =>
                                setState(() => selectedValue1 = val),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: _CustomDropDown(
                            items: List.generate(31, (index) => '${index + 1}'),
                            hint: 'Day',
                            value: selectedValue2,
                            onChanged: (val) =>
                                setState(() => selectedValue2 = val),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: _CustomDropDown(
                            items: List.generate(100,
                                (index) => '${DateTime.now().year - index}'),
                            hint: 'Year',
                            value: selectedValue3,
                            onChanged: (val) =>
                                setState(() => selectedValue3 = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '   Gender',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        SizedBox(
                          width: 180,
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Male'),
                            value: 'Male',
                            groupValue: gender,
                            onChanged: (val) => setState(() => gender = val),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Female'),
                            value: 'Female',
                            groupValue: gender,
                            onChanged: (val) => setState(() => gender = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'email address',
                        hintStyle: const TextStyle(color: Color(0xFFB1ADAD)),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'New password',
                        hintStyle: const TextStyle(color: Color(0xFFB1ADAD)),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
                        hintStyle: const TextStyle(color: Color(0xFFB1ADAD)),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(150, 40),
                      ),
                      onPressed: _loading ? null : _signUp,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed:
                          _loading ? null : () => handleGoogleSignIn(context),
                      child: const Text(
                        'Continue with Google',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        'Already have an account?',
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

class _CustomDropDown extends StatelessWidget {
  final List<String> items;
  final String hint;
  final String? value;
  final ValueChanged<String?> onChanged;

  const _CustomDropDown({
    required this.items,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        hint: Text(hint),
        initialValue: value,
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        dropdownColor: Colors.white,
        menuMaxHeight: 5 * 48.0,
      ),
    );
  }
}
