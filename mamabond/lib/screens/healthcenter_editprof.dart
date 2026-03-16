// healthcenter_editprof.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/screens/healthcenter_prof.dart';
import 'package:mamabond/screens/healthcenter_notif.dart';
import 'package:mamabond/service/login.dart';

class HealthCenterEditProf extends StatefulWidget {
  const HealthCenterEditProf({super.key});

  @override
  State<HealthCenterEditProf> createState() =>
      _HealthCenterEditProfState();
}

class _HealthCenterEditProfState
    extends State<HealthCenterEditProf> {

  final TextEditingController usernameController =
      TextEditingController(text: "BagoHealthCenter");

  final TextEditingController fullnameController =
      TextEditingController(text: "Bago Health Center");

  final TextEditingController emailController =
      TextEditingController(text: "healthcenter@gmail.com");

  final TextEditingController streetController =
      TextEditingController(text: "Agton Street");

  final TextEditingController barangayController =
      TextEditingController(text: "Toril");

  final TextEditingController cityController =
      TextEditingController(text: "Davao City");

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // ================= BACKGROUND =================
          Positioned.fill(
            child: Image.asset(
              "assets/background.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                // ================= TOP BAR =================
                Container(
                  height: 80,
                  color: const Color(0xFFFFE3E8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      Positioned(
                        left: 16,
                        child: Image.asset(
                          "assets/logo.notext.png",
                          width: 42,
                        ),
                      ),

                      Text(
                        "MamaBond",
                        style: GoogleFonts.lobster(
                          fontSize: 36,
                          color: const Color(0xFFE94E80),
                        ),
                      ),

                      // ✅ CONNECTED NOTIF (Health Center)
                      Positioned(
                        right: 16,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const HealthcenterNotif(),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.notifications,
                            color: Color(0xFFE94E80),
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [

                        const SizedBox(height: 10),

                        const CircleAvatar(
                          radius: 65,
                          backgroundColor: Color(0xFFE94E80),
                          child: Icon(
                            Icons.local_hospital,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20),

                        _buildField(usernameController),
                        const SizedBox(height: 10),
                        _buildField(fullnameController),
                        const SizedBox(height: 10),
                        _buildField(emailController),
                        const SizedBox(height: 10),
                        _buildField(streetController),
                        const SizedBox(height: 10),
                        _buildField(barangayController),
                        const SizedBox(height: 10),
                        _buildField(cityController),

                        const SizedBox(height: 25),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "CHANGE PASSWORD:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE94E80),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        _buildField(passwordController,
                            obscure: true,
                            hint: "Password"),

                        const SizedBox(height: 10),

                        _buildField(confirmPasswordController,
                            obscure: true,
                            hint: "Confirm Password"),

                        const SizedBox(height: 30),

                        // ================= SAVE =================
                        ElevatedButton(
                          onPressed: () {

                            if (passwordController.text.isNotEmpty &&
                                passwordController.text !=
                                    confirmPasswordController.text) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Passwords do not match"),
                                ),
                              );
                              return;
                            }

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const HealthCenterProfileScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFE94E80),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 12),
                          ),
                          child: const Text(
                            "save",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // ================= SIGN OUT =================
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginPage(),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFE94E80),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text("sign out"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller,
      {bool obscure = false,
      String? hint}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF3E4E1),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide:
              const BorderSide(color: Color(0xFFE94E80)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
              color: Color(0xFFE94E80),
              width: 2),
        ),
      ),
    );
  }
}