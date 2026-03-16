import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/screens/healthcenterpost.dart';
import 'package:mamabond/screens/healthcenter_notif.dart';
import 'package:mamabond/screens/healthcenter_prof.dart';

class HealthCenterHome extends StatelessWidget {
  const HealthCenterHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE9E6),
      body: SafeArea(
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
        builder: (context) =>
            const HealthcenterNotif(),
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

            // ================= BODY =================
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

                    // ================= ACTION BUTTONS =================
                    Row(
                      children: [

                        // ✅ NEW POST BUTTON
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const HealthCenterCreatePostScreen(),
                                ),
                              );
                            },
                            child: _squareActionCard(
                              icon: Icons.add,
                              label: 'New Post',
                              bgColor: const Color(0xFFFAAFB9),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _squareActionCard(
                            icon: Icons.home_work_rounded,
                            label: 'MilkBank',
                            bgColor: const Color(0xFFF59AB5),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _squareActionCard(
                            icon: Icons.pregnant_woman,
                            label: 'Breastfeed\nStation',
                            bgColor: const Color(0xFFE94E80),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
  child: InkWell(
    borderRadius: BorderRadius.circular(22),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const HealthCenterProfileScreen(),
        ),
      );
    },
    child: _squareActionCard(
      icon: Icons.person_outline,
      label: 'Profile',
      bgColor: const Color(0xFFFCE1E6),
      borderOnly: true,
    ),
  ),
),
                      ],
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
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SQUARE ACTION CARD
  // =========================================================

  static Widget _squareActionCard({
    required IconData icon,
    required String label,
    required Color bgColor,
    bool borderOnly = false,
  }) {
    return Container(
      height: 95,
      decoration: BoxDecoration(
        color: borderOnly ? Colors.transparent : bgColor,
        borderRadius: BorderRadius.circular(22),
        border:
            borderOnly ? Border.all(color: const Color(0xFFE94E80)) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color:
                borderOnly ? const Color(0xFFE94E80) : Colors.white,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: borderOnly
                  ? const Color(0xFFE94E80)
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // POST CARD WITH LIKE & COMMENT
  // =========================================================

  static Widget _postCard() {
    return Container(
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
                  'TORIL HEALTH CENTER\nAgton Street, Toril Davao City',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Text(
                'EDIT INFO',
                style: TextStyle(
                  color: Color(0xFFE94E80),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            '🍼 "How to Store Breast Milk Properly"',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Summary: A quick guide on proper storage methods for expressed milk...',
            style: TextStyle(fontSize: 13),
          ),

          const SizedBox(height: 10),

          const Text(
            'Posted on: July 29, 2025',
            style: TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 16),

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
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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