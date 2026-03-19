//mother_home.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'motherpost.dart';
import 'package:mamabond/screens/healthcenterview.dart';
import 'package:mamabond/screens/mothernotif.dart';
import 'package:mamabond/screens/motherprofile.dart';
import 'package:mamabond/screens/milkbank_locator.dart';
import 'package:mamabond/screens/bf_station_locator.dart'; // ✅ IMPORT ADDED

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // ✅ BACKGROUND IMAGE
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
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE3E8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/logo.notext.png', width: 42),
                      Text(
                        'MamaBond',
                        style: GoogleFonts.lobster(
                          fontSize: 32,
                          color: const Color(0xFFE94E80),
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
                          color: Color(0xFFE94E80),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [

                        // ================= SEARCH =================
                        Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8A8B8),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Colors.white),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Search MamaBond',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Icon(Icons.tune, color: Colors.white),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ================= QUICK ACTION SECTION =================
                        Row(
                          children: [

                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreatePostScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAAFB9),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,
                                          size: 26, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'ADD NEW POST',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [

                                  Row(
                                    children: [

                                      // ✅ STATION BUTTON → FeedingStationLocator
                                      _smallAction(
                                        icon: Icons.pregnant_woman,
                                        label: 'Station',
                                        bgColor: const Color(0xFFE94E80),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const FeedingStationLocator(),
                                            ),
                                          );
                                        },
                                      ),

                                      const SizedBox(width: 12),

                                      // ✅ MILKBANK BUTTON → MilkbankLocator
                                      _smallAction(
                                        icon: Icons.home_work_rounded,
                                        label: 'MilkBank',
                                        bgColor: const Color(0xFFF59AB5),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MilkbankLocator(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    children: [

                                      Expanded(
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const HealthCenterViewProfileScreen(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFAAFB9)
                                                  .withOpacity(0.65),
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.local_hospital,
                                                    size: 22,
                                                    color: Colors.white),
                                                SizedBox(height: 4),
                                                Text(
                                                  'HealthCenter',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const MotherProfileScreen(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color:
                                                  const Color(0xFFF25A88),
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.person,
                                                    size: 22,
                                                    color: Colors.white),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Profile',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        _glassPostCard(),
                        const SizedBox(height: 18),
                        _glassPostCard(),
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

  // ✅ SMALL ACTION WIDGET (WITH onTap)
  static Widget _smallAction({
    required IconData icon,
    required String label,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: Colors.white),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _glassPostCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
            ),
          ),
          child: const Text("Glass Post"),
        ),
      ),
    );
  }
}