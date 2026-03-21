import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/controllers/mother_editprof_controller.dart';
import 'package:mamabond/screens/mothernotif.dart';
import 'package:mamabond/service/login.dart';

class MotherEditprof extends StatefulWidget {
  const MotherEditprof({super.key});

  @override
  State<MotherEditprof> createState() => _MotherEditprofState();
}

class _MotherEditprofState extends State<MotherEditprof> {
  final MotherEditprofController controller = MotherEditprofController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final error = await controller.loadMotherProfile();

    if (!mounted) return;

    setState(() {});

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  Future<void> _saveProfile() async {
    setState(() {});

    final result = await controller.saveProfile();

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? 'Unknown message')),
    );

    if (result['success'] == true) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _signOut() async {
    final result = await controller.signOut();

    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Failed to sign out')),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8EFE8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 62,
              color: const Color(0xFFF7C9D3),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Image.asset(
                    "assets/logo.notext.png",
                    width: 42,
                    height: 42,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "MamaBond",
                      style: GoogleFonts.lobster(
                        fontSize: 30,
                        color: const Color(0xFFE85A8B),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Mothernotif(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.notifications,
                      color: Color(0xFFE85A8B),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6C3CF),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: const EdgeInsets.fromLTRB(18, 26, 18, 26),
                            child: Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFF4A9BB),
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        size: 85,
                                        color: Color(0xFFE85A8B),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 4,
                                      right: -2,
                                      child: Container(
                                        width: 46,
                                        height: 46,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Color(0xFFE85A8B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                _buildField(
                                  controller.usernameController,
                                  hint: "username",
                                ),
                                const SizedBox(height: 14),
                                _buildField(
                                  controller.fullNameController,
                                  hint: "full name",
                                ),
                                const SizedBox(height: 14),
                                _buildField(
                                  controller.streetController,
                                  hint: "address",
                                ),
                                const SizedBox(height: 14),
                                _buildField(
                                  controller.barangayController,
                                  hint: "barangay",
                                  readOnly: true,
                                ),
                                const SizedBox(height: 14),
                                _buildField(
                                  controller.cityController,
                                  hint: "City",
                                  readOnly: true,
                                ),
                                const SizedBox(height: 34),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Change password screen not connected yet',
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEE6D98),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "CHANGE PASSWORD",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 26),
                                SizedBox(
                                  width: screenWidth * 0.34,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: controller.isSaving ? null : _saveProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEE6D98),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                    ),
                                    child: Text(
                                      controller.isSaving ? "saving..." : "save",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 120,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _signOut,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEE6D98),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: const Text(
                                  "sign out",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
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
      ),
    );
  }

  Widget _buildField(
    TextEditingController textController, {
    bool obscure = false,
    bool readOnly = false,
    String? hint,
  }) {
    return SizedBox(
      height: 52,
      child: TextField(
        controller: textController,
        obscureText: obscure,
        readOnly: readOnly,
        style: TextStyle(
          fontSize: 17,
          color: readOnly ? const Color(0xFFB78493) : const Color(0xFFE85A8B),
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFEFA0B7),
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: readOnly
              ? const Color(0xFFF1E8E4)
              : const Color(0xFFF9F1EA),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color(0xFFEE6D98),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color(0xFFEE6D98),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}