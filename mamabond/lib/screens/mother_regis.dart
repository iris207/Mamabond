import 'dart:ui';
import 'package:flutter/material.dart';
import '../controllers/mother_regis_controller.dart';
import '../snackbar/snackbar.dart';

class RegisterMotherScreen extends StatefulWidget {
  const RegisterMotherScreen({super.key});

  @override
  State<RegisterMotherScreen> createState() => _RegisterMotherScreenState();
}

class _RegisterMotherScreenState extends State<RegisterMotherScreen> {
  final RegisterController _controller = RegisterController();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController fullAddressController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool passwordMismatch = false;

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

  Future<void> _registerMother() async {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() => passwordMismatch = true);
      return;
    }

    setState(() {
      isLoading = true;
      passwordMismatch = false;
    });

    final error = await _controller.registerMother(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      username: usernameController.text.trim(),
      address: fullAddressController.text.trim(),
      city: selectedCity ?? '',
      barangay: selectedBarangay ?? '',
    );

    setState(() => isLoading = false);

    if (error == null) {
      AppSnackbar.success(context, 'Registration successful!');
    } else {
      AppSnackbar.error(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background.png', fit: BoxFit.cover),
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
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset('assets/logo.png', height: 110),
                        const SizedBox(height: 16),
                        const Text(
                          'MOTHER REGISTRATION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE94E80),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _field('Full Name', fullNameController),
                        _field('Email', emailController),
                        _field('Username', usernameController),
                        _passwordField(
                          hint: 'Password',
                          controller: passwordController,
                          obscure: obscurePassword,
                          toggle: () =>
                              setState(() => obscurePassword = !obscurePassword),
                        ),
                        _passwordField(
                          hint: 'Confirm Password',
                          controller: confirmPasswordController,
                          obscure: obscureConfirmPassword,
                          toggle: () => setState(() =>
                              obscureConfirmPassword = !obscureConfirmPassword),
                          error: passwordMismatch,
                        ),
                        _field(
                          'Full Address (Street / House No.)',
                          fullAddressController,
                        ),
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
                          onChanged: (value) =>
                              setState(() => selectedBarangay = value),
                        ),
                        const SizedBox(height: 28),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _registerMother,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE94E80),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
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
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
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
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}