import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/screens/mother_home.dart';
import '../screens/mother_regis.dart';
import '../screens/healthcenter_regis.dart';
import '../controllers/auth_controller.dart';
import '../screens/healthcenter_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  // 🔹 CONTROLLERS 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🔹 LOGIN FUNCTION
 Future<void> _login() async {
  final controller = AuthController();

  final result = await controller.login(
    usernameOrEmail: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  );

  if (result['success'] == true) {
    final userType = result['userType'];

    if (userType == 'MOTHER') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } else if (userType == 'HEALTHCENTER') {
      // Temporary: send health center to same screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HealthCenterHome(),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? 'Login failed')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // BACKGROUND
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
          ),

          // SOFT OVERLAY
          Container(
            color: Colors.white.withOpacity(0.05),
          ),

          // MAIN CONTENT
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LOGO
                  Image.asset(
                    'assets/logo.png',
                    width: 160,
                  ),

                  const SizedBox(height: 32),

                  // GLASS CONTAINER
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // EMAIL
                            _label('EMAIL'),
                            _glassTextField(
                              hint: 'Enter your email',
                              obscure: false,
                              controller: _emailController,
                            ),

                            const SizedBox(height: 16),

                            // PASSWORD
                            _label('PASSWORD'),
                            _glassPasswordField(),

                            const SizedBox(height: 24),

                            // LOGIN BUTTON ✅ CONNECTED
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE94E80),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'LOGIN',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Center(
                              child: Text(
                                "don’t have an account?",
                                style: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Center(
                              child: Text(
                                'Select your role to register:',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // ROLE BUTTONS
                            Row(
                              children: [
                                Expanded(child: _roleButton('Mother')),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: _roleButton('Health Center')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  // HELPER WIDGETS
  // ============================

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFE94E80),
      ),
    );
  }

  Widget _glassTextField({
    required String hint,
    required bool obscure,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: Colors.white.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _glassPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: 'Enter your password',
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: Colors.white.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off
                : Icons.visibility,
            color: Colors.black45,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }

  // ============================
  // ROLE BUTTONS (REGISTRATION)
  // ============================

  Widget _roleButton(String text) {
    return ElevatedButton(
      onPressed: () {
        if (text == 'Mother') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegisterMotherScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegisterHealthCenterScreen(),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE94E80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.white,
        ),
      ),
    );
  }
}
