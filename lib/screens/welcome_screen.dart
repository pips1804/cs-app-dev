import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _showLoginModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LoginModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3333),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Let's get started!",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/sample-logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA5C9CA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                minimumSize: const Size(100, 50),
              ),
              onPressed: () => _showLoginModal(context),
              child: const Text("Get Started",
                  style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _obscureText = true;
  bool _isLoading = false;

  void loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String? result = await _authService.signIn(email, password);

    setState(() {
      _isLoading = false;
    });

    if (result == null) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2C3333),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              const Icon(Icons.check_circle,
                  color: Color(0xFFA5C9CA), size: 30),
              const SizedBox(width: 10),
              const Text("Login Successful",
                  style: TextStyle(color: Color(0xFFA5C9CA))),
            ],
          ),
          content: const Text("Welcome back!",
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close success dialog
                Navigator.pop(context); // Close login modal
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child:
                  const Text("OK", style: TextStyle(color: Color(0xFFA5C9CA))),
            ),
          ],
        ),
      );
    } else {
      // **Clear text fields when login fails**
      emailController.clear();
      passwordController.clear();

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2C3333),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              const Icon(Icons.cancel, color: Colors.redAccent, size: 30),
              const SizedBox(width: 10),
              const Text("Login Failed",
                  style: TextStyle(color: Colors.redAccent)),
            ],
          ),
          content: const Text("Email or password is incorrect.",
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text("OK", style: TextStyle(color: Color(0xFFA5C9CA))),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.7,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2C3333),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Text("Log In",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFE7F6F2),
                        hintText: "Email Address",
                        prefixIcon: const Icon(Icons.email, color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFE7F6F2),
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () =>
                              setState(() => _obscureText = !_obscureText),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA5C9CA),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        minimumSize: const Size(100, 50),
                      ),
                      onPressed: _isLoading ? null : loginUser,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Log In",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
