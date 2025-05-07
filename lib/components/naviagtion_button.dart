import 'package:flutter/material.dart';

class NaviagtionButton extends StatelessWidget {
  final String buttonText;
  final IconData icon;
  final VoidCallback onPressed;
  final double left;

  const NaviagtionButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.icon,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color.fromARGB(255, 236, 116, 12), // Main color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: left,
            ),
            elevation: 4,
            shadowColor: Colors.orangeAccent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 22.0,
                  color: const Color.fromARGB(
                      255, 236, 116, 12), // Match app color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
