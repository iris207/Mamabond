//healthcenterpost.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/controllers/healthcenter_post_controller.dart';

class HealthCenterCreatePostScreen extends StatefulWidget {
  const HealthCenterCreatePostScreen({super.key});

  @override
  State<HealthCenterCreatePostScreen> createState() =>
      _HealthCenterCreatePostScreenState();
}

class _HealthCenterCreatePostScreenState
    extends State<HealthCenterCreatePostScreen> {
  final HealthcenterPostController controller = HealthcenterPostController();

  Future<void> _createPost() async {
    setState(() {});

    final result = await controller.createPost();

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] ?? 'Unknown message'),
      ),
    );

    if (result['success'] == true) {
      Navigator.pop(context, true);
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
      backgroundColor: const Color(0xFFDDB7BC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 80,
                color: const Color(0xFFFFE3E8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 16,
                      child: Image.asset(
                        "assets/logo.png",
                        height: 42,
                      ),
                    ),
                    Center(
                      child: Text(
                        "MamaBond",
                        style: GoogleFonts.lobster(
                          fontSize: 36,
                          color: const Color(0xFFE94E80),
                        ),
                      ),
                    ),
                    const Positioned(
                      right: 16,
                      child: Icon(
                        Icons.notifications,
                        color: Color(0xFFE94E80),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Create a Post to share with Moms",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE94E80),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE94E80),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Post Title:",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: controller.titleController,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Category:",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: controller.categoryController,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Description:",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8DFD6),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: controller.descriptionController,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Photo upload not connected yet'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.upload),
                          label: const Text("UPLOAD"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8DFD6),
                            foregroundColor: const Color(0xFFE94E80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: controller.isPosting ? null : _createPost,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8DFD6),
                            foregroundColor: const Color(0xFFE94E80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            controller.isPosting ? "POSTING..." : "POST",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildInputField({
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8DFD6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }
}