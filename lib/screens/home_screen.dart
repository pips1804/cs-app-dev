import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'welcome_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _scanCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C3333), // Dark background
        title: const Text(
          "Scan QR Code/Bar Code",
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: 300,
          height: 300,
          child: MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  String scannedData = barcode.rawValue!;
                  Navigator.pop(context); // Close scanner

                  // Show the scanned link as a clickable button
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF2C3333),
                      title: const Text(
                        "Scanned Result",
                        style: TextStyle(color: Colors.white),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            scannedData,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              // Open the URL in a browser
                              launchURL(scannedData);
                            },
                            child: const Text(
                              "Open Link",
                              style: TextStyle(color: Color(0xFFA5C9CA)),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Close",
                            style: TextStyle(color: Color(0xFFA5C9CA)),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Close", style: TextStyle(color: Color(0xFFA5C9CA))),
          ),
        ],
      ),
    );
  }

// Function to launch URL
  void launchURL(String url) async {
    Uri uri = Uri.parse(url); // Ensure the URL is properly formatted
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: LaunchMode.externalApplication); // Opens in browser
    } else {
      debugPrint("Could not launch $url");
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C3333), // Dark background
        title: const Text(
          "Confirm Logout",
          style: TextStyle(color: Color(0xFFA5C9CA)),
        ),
        content: const Text(
          "Are you sure you want to log out?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Color(0xFFA5C9CA))),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: const Text("Logout",
                style: TextStyle(color: Color(0xFFA5C9CA))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: const Color(0xFFA5C9CA),
        foregroundColor: const Color(0xFF2C3333),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: user != null
                ? const Text(
                    "Welcome, Admin!",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                : const Text(
                    "No user logged in",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
          ),
          const SizedBox(height: 50),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA5C9CA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              minimumSize: const Size(250, 50),
            ),
            onPressed: () => _scanCode(context),
            icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
            label: const Text(
              "Scan QR / Barcode",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          )
        ],
      ),
      backgroundColor: const Color(0xFF2C3333),
    );
  }
}
