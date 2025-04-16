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
        backgroundColor: const Color(0xFF2C3333),
        title: const Text(
          "Logout",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Color(0xFFA5C9CA)),
            ),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Color(0xFFA5C9CA)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sample product details for demonstration
    List<Map<String, String>> products = [
      {
        'name': 'Product 1',
        'price': '\$19.99',
        'description': 'A great product for your needs!',
      },
      {
        'name': 'Product 2',
        'price': '\$29.99',
        'description': 'This product is a must-have!',
      },
      {
        'name': 'Product 3',
        'price': '\$39.99',
        'description': 'Perfect for any occasion.',
      },
      {
        'name': 'Product 4',
        'price': '\$49.99',
        'description': 'Top quality and performance.',
      },
      {
        'name': 'Product 5',
        'price': '\$59.99',
        'description': 'A premium choice for you.',
      },
      {
        'name': 'Product 6',
        'price': '\$69.99',
        'description': 'Affordable luxury.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF2C3333),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3333),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFA5C9CA)),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA5C9CA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => _scanCode(context),
                child: const Text(
                  "Scan QR/Barcode",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Our Products",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  itemCount: 6, // Number of dummy products
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Show product details in modal
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFF2C3333),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text(
                                "Product Details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.shopping_bag,
                                      size: 60, color: Colors.white70),
                                  const SizedBox(height: 10),
                                  Text(
                                    products[index]['name']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    products[index]['price']!,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    products[index]['description']!,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
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
                            );
                          },
                        );
                      },
                      child: Card(
                        color: const Color(0xFFA5C9CA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_bag,
                                size: 60, color: Colors.black87),
                            const SizedBox(height: 10),
                            Text(
                              "Product ${index + 1}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "\$19.99",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
