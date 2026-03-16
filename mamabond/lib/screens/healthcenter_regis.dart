//healthcenter_regis.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../controllers/healthcenter_regis_controller.dart';

class RegisterHealthCenterScreen extends StatefulWidget {
  const RegisterHealthCenterScreen({super.key});

  @override
  State<RegisterHealthCenterScreen> createState() =>
      _RegisterHealthCenterScreenState();
}

class _RegisterHealthCenterScreenState
    extends State<RegisterHealthCenterScreen> {
  final HealthcenterRegisController _controller = HealthcenterRegisController();

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController centerNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactNumberController =
      TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool passwordMismatch = false;

  // ---------------- CITY & BARANGAY ----------------
  String? selectedCity;
  String? selectedBarangay;

  final Map<String, List<String>> mindanaoCities = {
    'Davao City': ['Buhangin', 'Talomo', 'Toril', 'Bunawan'],
    'Cagayan de Oro': ['Carmen', 'Lapasan', 'Macasandig'],
    'General Santos': ['Lagao', 'San Isidro', 'Calumpang'],
    'Zamboanga City': ['Tetuan', 'Putik', 'Tumaga'],
    'Butuan City': ['Ampayon', 'Libertad', 'Banza'],
  };

  List<String> get barangays =>
      selectedCity == null ? [] : mindanaoCities[selectedCity]!;

  // ---------------- REGISTER ----------------
  Future<void> _registerHealthCenter() async {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() => passwordMismatch = true);
      return;
    }

    setState(() {
      isLoading = true;
      passwordMismatch = false;
    });

    final error = await _controller.registerHealthCenter(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      centerName: centerNameController.text.trim(),
      city: selectedCity ?? '',
      barangay: selectedBarangay ?? '',
      contactNumber: contactNumberController.text.trim(),
    );

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? 'Health center registered successfully!',
        ),
        backgroundColor: error == null ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ---------------- BACKGROUND ----------------
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
          ),

          // ---------------- FORM ----------------
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ---------------- LOGO ----------------
                        Image.asset(
                          'assets/logo.png',
                          height: 110,
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'HEALTH CENTER REGISTRATION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE94E80),
                          ),
                        ),

                        const SizedBox(height: 24),

                        _dropdown(
                          hint: 'City',
                          value: selectedCity,
                          items: mindanaoCities.keys.toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCity = value;
                              selectedBarangay = null;
                            });
                          },
                        ),

                        _dropdown(
                          hint: 'Barangay',
                          value: selectedBarangay,
                          items: barangays,
                          onChanged: (value) {
                            setState(() {
                              selectedBarangay = value;
                            });
                          },
                        ),

                        _field(
                            'Health Center Name', centerNameController),
                        _field('Health Center Address', addressController),
                        _field(
                            'Contact Number', contactNumberController),
                        _field('Official Email', emailController),

                        _passwordField(
                          hint: 'Password',
                          controller: passwordController,
                          obscure: obscurePassword,
                          toggle: () => setState(
                              () => obscurePassword = !obscurePassword),
                        ),

                        _passwordField(
                          hint: 'Confirm Password',
                          controller: confirmPasswordController,
                          obscure: obscureConfirmPassword,
                          toggle: () => setState(() =>
                              obscureConfirmPassword =
                                  !obscureConfirmPassword),
                          error: passwordMismatch,
                        ),

                        const SizedBox(height: 28),

                        isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed: _registerHealthCenter,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFFE94E80),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'REGISTER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- HELPERS ----------------

  Widget _field(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white.withOpacity(0.6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
    bool error = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white.withOpacity(0.6),
          errorText: error ? 'Passwords do not match' : null,
          suffixIcon: IconButton(
            icon:
                Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hint),
          value: value,
          isExpanded: true,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}