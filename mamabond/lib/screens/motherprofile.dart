import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/screens/mothernotif.dart';
import 'package:mamabond/screens/mother_editprof.dart';

class MotherProfileScreen extends StatelessWidget {
  const MotherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // ================= BACKGROUND =================
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
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
                    children: [

                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFFE94E80),
                        child: Icon(
                          Icons.person,
                          size: 55,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Mary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE94E80),
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Puan, Davao City",
                        style: TextStyle(
                          color: Color(0xFFE94E80),
                        ),
                      ),

                      const SizedBox(height: 15),

                     ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const MotherEditprof(),
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
  ),
  child: const Text("EDIT INFO"),
),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // ================= YOUR POSTS TITLE =================
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "YOUR POSTS:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFE94E80),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: const [
                        _MotherPostCard(),
                        SizedBox(height: 20),
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
}

// =========================================================
// POST CARD
// =========================================================

class _MotherPostCard extends StatelessWidget {
  const _MotherPostCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFBC1CC),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          // HEADER
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Color(0xFFE94E80),
                    child: Icon(Icons.person,
                        color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Mary",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xFFE94E80),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "EDIT POST",
                    style: TextStyle(
                      color:
                          Color(0xFFE94E80),
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.edit,
                      color:
                          Color(0xFFE94E80),
                      size: 18),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          // CONTENT BOX
          Container(
            padding:
                const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFE89AA8),
              borderRadius:
                  BorderRadius.circular(
                      20),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: const [

                Text(
                  '🍼 “How to Store Breast Milk Properly”',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Summary: “A quick guide on proper storage methods for expressed milk, including room temp, refrigeration, and freezing times.”',
                  style: TextStyle(
                      fontSize: 13),
                ),

                SizedBox(height: 8),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    Text(
                      "Posted on: July 29, 2025",
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            Colors.black54,
                      ),
                    ),
                    Text(
                      "see more ...",
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            Color(0xFFE94E80),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // LIKE & COMMENT BUTTONS
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: const [
              _PostActionButton(
                icon: Icons.favorite_border,
                label: "Like 215",
              ),
              _PostActionButton(
                icon: Icons.chat_bubble_outline,
                label: "Comment 0",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =========================================================
// BUTTON STYLE
// =========================================================

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
      padding: const EdgeInsets.symmetric(
          horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE94E80),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFFE94E80),
          ),
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