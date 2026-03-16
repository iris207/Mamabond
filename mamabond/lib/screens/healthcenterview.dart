//healthcenterview.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthCenterViewProfileScreen extends StatelessWidget {
  const HealthCenterViewProfileScreen({super.key});

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
                height: 80,
                color: const Color(0xFFFFE3E8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    // LEFT LOGO
                    Positioned(
                      left: 16,
                      child: Image.asset(
                        "assets/logo.png",
                        height: 42,
                      ),
                    ),

                    // CENTER TEXT (LOBSTER)
                    Text(
                      "MamaBond",
                      style: GoogleFonts.lobster(
                        fontSize: 36,
                        color: const Color(0xFFE94E80),
                      ),
                    ),

                    // RIGHT NOTIFICATION
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

              // ================= PROFILE CARD =================
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7B5BC),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Color(0xFFE94E80),
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "TORIL HEALTH CENTER",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE94E80),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Agton Street,Toril Davao City",
                      style: TextStyle(
                        color: Color(0xFFE94E80),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ================= POSTS =================
              _postCard(),
              const SizedBox(height: 20),
              _postCard(),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // POST CARD WITH LIKE & COMMENT
  // =========================================================

  static Widget _postCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFBC1CC),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: const [
              CircleAvatar(
                backgroundColor: Color(0xFFE94E80),
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'TORIL HEALTH CENTER\nAgton Street,Toril Davao City',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE89AA8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🍼 "How to Store Breast Milk Properly"',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Summary: “A quick guide on proper storage methods for expressed milk, including room temp, refrigeration, and freezing times.”',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 8),
                Text(
                  "Posted on: July 29, 2025",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ❤️ LIKE & 💬 COMMENT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _PostActionButton(
                icon: Icons.favorite_border,
                label: 'Like',
              ),
              _PostActionButton(
                icon: Icons.chat_bubble_outline,
                label: 'Comment',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PostActionButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE94E80)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFE94E80)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFE94E80),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}