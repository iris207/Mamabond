import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/controllers/healthcenter_editprof_controller.dart';
import 'package:mamabond/screens/healthcenter_notif.dart';
import 'package:mamabond/service/login.dart';

class HealthCenterEditProf extends StatefulWidget {
  const HealthCenterEditProf({super.key});

  @override
  State<HealthCenterEditProf> createState() => _HealthCenterEditProfState();
}

class _HealthCenterEditProfState extends State<HealthCenterEditProf> {
  final HealthcenterEditprofController controller =
      HealthcenterEditprofController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final error = await controller.loadHealthCenterProfile();

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
    return Scaffold(
      backgroundColor: const Color(0xFFF7EFE8),
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
                          builder: (context) => const HealthcenterNotif(),
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
                      padding: const EdgeInsets.fromLTRB(10, 12, 10, 18),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4C6D0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 170,
                                      height: 170,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFF2AEBE),
                                      ),
                                      child: const Icon(
                                        Icons.local_hospital,
                                        size: 90,
                                        color: Color(0xFFE85A8B),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      right: -2,
                                      child: Container(
                                        width: 54,
                                        height: 54,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Color(0xFFE85A8B),
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 26),
                                _buildField(
                                  controller.centerNameController,
                                  hint: 'center name',
                                ),
                                const SizedBox(height: 16),
                                _buildField(
                                  controller.emailController,
                                  hint: 'email',
                                  readOnly: true,
                                ),
                                const SizedBox(height: 16),
                                _buildField(
                                  controller.contactNumberController,
                                  hint: 'contact',
                                ),
                                const SizedBox(height: 16),
                                _buildField(
                                  controller.addressController,
                                  hint: 'address',
                                ),
                                const SizedBox(height: 16),
                                _buildField(
                                  controller.barangayController,
                                  hint: 'barangay',
                                  readOnly: true,
                                ),
                                const SizedBox(height: 16),
                                _buildField(
                                  controller.cityController,
                                  hint: 'city',
                                  readOnly: true,
                                ),
                                const SizedBox(height: 26),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "CHANGE PASSWORD",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),
                                SizedBox(
                                  width: 110,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed:
                                        controller.isSaving ? null : _saveProfile,
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
    String? hint,
    bool readOnly = false,
  }) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: textController,
        readOnly: readOnly,
        style: TextStyle(
          fontSize: 16,
          color: readOnly
              ? const Color(0xFFB78493)
              : const Color(0xFFE85A8B),
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