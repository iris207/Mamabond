//mothernotif.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Mothernotif extends StatelessWidget {
  const Mothernotif({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // ================= BACKGROUND IMAGE =================
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
                          "assets/logo.png",
                          height: 42,
                        ),
                      ),

                      Text(
                        "MamaBond",
                        style: GoogleFonts.lobster(
                          fontSize: 36,
                          color: const Color(0xFFE94E80),
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

                // ================= TITLE =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Notification",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE94E80),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ================= GLASS NOTIFICATION CARD =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 15,
                        sigmaY: 15,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius:
                              BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white
                                .withOpacity(0.4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: const [

                            Row(
                              children: [
                                Icon(Icons.notifications,
                                    color:
                                        Color(0xFFE94E80)),
                                SizedBox(width: 10),
                                Text(
                                  "Bago Healthcenter",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        Color(0xFFE94E80),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12),

                            Text(
                              '🍼 "How to Store Breast Milk"',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              'Summary: “A quick guide on proper storage methods for expressed milk, including room temp, refrigeration, and freezing times”',
                              style:
                                  TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
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