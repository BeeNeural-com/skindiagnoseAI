import 'package:dtreatyflutter/auth/login_screen.dart';
import 'package:dtreatyflutter/network/network_utils.dart';
import 'package:dtreatyflutter/pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/naviagtion_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _checkUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    bool isConnected = await NetworkUtils.isConnected();

    if (user != null || !isConnected) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Pattern or Light Texture
            Positioned.fill(
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  "./assets/images/background_texture.png", // <- Add a light dermatology/skin-related background image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Main Content
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Logo or Icon
                  Center(
                    child: Image.asset(
                      "./assets/images/logo.jpg", // <- Your App logo related to skin health
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Title Text
                  const Text(
                    "Healthy Skin,\nConfident You",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color:
                          Color.fromARGB(255, 236, 116, 12), // Main theme color
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Subtitle Text
                  const Text(
                    "Detect skin diseases early and\nlearn how to prevent them.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Try Button
                  NaviagtionButton(
                    buttonText: "Get Started",
                    icon: Icons.arrow_forward_ios_rounded,
                    left: 20.0,
                    onPressed: _checkUser,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
