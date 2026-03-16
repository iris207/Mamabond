import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/screens/motherprofile.dart';
import 'package:mamabond/screens/mothernotif.dart';
import 'package:mamabond/service/login.dart';

class MotherEditprof extends StatefulWidget {
  const MotherEditprof({super.key});

  @override
  State<MotherEditprof> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<MotherEditprof> {

  final TextEditingController usernameController =
      TextEditingController(text: "mary");

  final TextEditingController fullnameController =
      TextEditingController(text: "Mary Florence Timtim");

  final TextEditingController emailController =
      TextEditingController(text: "mary@gmail.com");

  final TextEditingController streetController =
      TextEditingController(text: "Puan street");

  final TextEditingController barangayController =
      TextEditingController(text: "Barangay");

  final TextEditingController cityController =
      TextEditingController(text: "City");

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

                      Positioned(
                        right: 16,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Mothernotif(),
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
                    padding:
                        const EdgeInsets.all(20),
                    child: Column(
                      children: [

                        const SizedBox(height: 10),

                        // PROFILE IMAGE
                        Stack(
                          children: [
                            const CircleAvatar(
                              radius: 65,
                              backgroundColor:
                                  Color(0xFFE94E80),
                              child: Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration:
                                    const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                padding:
                                    const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color:
                                      Color(0xFFE94E80),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // USERNAME
                        _buildField(usernameController),

                        const SizedBox(height: 10),

                        // FULLNAME
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
                          alignment:
                              Alignment.centerLeft,
                          child: Text(
                            "CHANGE PASSWORD:",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Color(0xFFE94E80),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        _buildField(passwordController,
                            obscure: true,
                            hint: "Password"),

                        const SizedBox(height: 10),

                        _buildField(
                            confirmPasswordController,
                            obscure: true,
                            hint:
                                "Confirm Password"),

                        const SizedBox(height: 30),

                        // SAVE BUTTON
                        ElevatedButton(
                          onPressed: () {

                            // Optional password check
                            if (passwordController
                                    .text.isNotEmpty &&
                                passwordController
                                        .text !=
                                    confirmPasswordController
                                        .text) {
                              ScaffoldMessenger.of(
                                      context)
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
                                    const MotherProfileScreen(),
                              ),
                            );
                          },
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                                    0xFFE94E80),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          30),
                            ),
                            padding:
                                const EdgeInsets
                                    .symmetric(
                                    horizontal:
                                        40,
                                    vertical:
                                        12),
                          ),
                          child: const Text(
                            "save",
                            style: TextStyle(
                                fontSize: 16),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // SIGN OUT
                        Align(
                          alignment:
                              Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const LoginPage(),
                                ),
                                (route) => false,
                              );
                            },
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(
                                      0xFFE94E80),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            30),
                              ),
                            ),
                            child:
                                const Text("sign out"),
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
            const EdgeInsets.symmetric(
                horizontal: 20),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(30),
          borderSide: const BorderSide(
              color: Color(0xFFE94E80)),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(30),
          borderSide: const BorderSide(
              color: Color(0xFFE94E80),
              width: 2),
        ),
      ),
    );
  }
}