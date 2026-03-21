import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDB7BC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ================= TOP BAR =================
              Container(
                height: 80, // increased height to prevent clipping
                color: const Color(0xFFFFE3E8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    // 🍼 LEFT LOGO
                    Positioned(
                      left: 16,
                      child: Image.asset(
                        "assets/logo.png",
                        height: 42,
                      ),
                    ),

                    // 💗 CENTERED TEXT
                    Center(
                      child: Text(
                        "MamaBond",
                        style: GoogleFonts.lobster(
                          fontSize: 36,
                          color: const Color(0xFFE94E80),
                        ),
                      ),
                    ),

                    // 🔔 RIGHT NOTIFICATION
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

              // ================= TITLE =================
              const Text(
                "Create a Post to share with Moms",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE94E80),
                ),
              ),

              const SizedBox(height: 20),

              // ================= MAIN CARD =================
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

                    // Post Title
                    const Text(
                      "Post Title:",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    _buildInputField(),

                    const SizedBox(height: 20),

                    // Category
                    const Text(
                      "Category:",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    _buildInputField(),

                    const SizedBox(height: 20),

                    // Description
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
                      child: const TextField(
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ================= BUTTONS =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        ElevatedButton.icon(
                          onPressed: () {},
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8DFD6),
                            foregroundColor: const Color(0xFFE94E80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("POST"),
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

  static Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8DFD6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }
}