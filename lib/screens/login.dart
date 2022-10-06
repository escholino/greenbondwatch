import 'package:flutter/material.dart';
import 'package:greenbondwatch/screens/home.dart';
import 'package:greenbondwatch/services/google_login_service.dart';

class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GoogleLoginScreenState createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseServices().signInWithGoogle();
                // ignore: use_build_context_synchronously
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.black26;
                }
                return Colors.white;
              })),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/google.png",
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Login with Gmail",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
