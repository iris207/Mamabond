//healthcenter_home.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/controllers/healthcenter_post_controller.dart';
import 'package:mamabond/screens/healthcenterpost.dart';
import 'package:mamabond/screens/healthcenter_notif.dart';
import 'package:mamabond/screens/healthcenter_prof.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthCenterHome extends StatefulWidget {
  const HealthCenterHome({super.key});

  @override
  State<HealthCenterHome> createState() => _HealthCenterHomeState();
}

class _HealthCenterHomeState extends State<HealthCenterHome> {
  final HealthcenterPostController controller = HealthcenterPostController();
  final SupabaseClient _client = Supabase.instance.client;

  String centerName = '';
  String fullAddress = '';

  @override
  void initState() {
    super.initState();
    _loadScreenData();
  }

  Future<void> _loadScreenData() async {
    await _loadHealthCenterInfo();
    final error = await controller.loadMyPosts();

    if (!mounted) return;

    setState(() {});

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  Future<void> _loadHealthCenterInfo() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) return;

      final profile = await _client
          .from('healthcenters')
          .select('center_name, address, barangay, city')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      if (profile != null) {
        final address = (profile['address'] ?? '').toString();
        final barangay = (profile['barangay'] ?? '').toString();
        final city = (profile['city'] ?? '').toString();

        final parts = [address, barangay, city]
            .where((part) => part.trim().isNotEmpty)
            .toList();

        centerName = (profile['center_name'] ?? '').toString();
        fullAddress = parts.join(', ');
      }
    } catch (e) {
      //
    }
  }

  Future<void> _goToCreatePost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HealthCenterCreatePostScreen(),
      ),
    );

    if (result == true) {
      controller.isLoadingPosts = true;
      setState(() {});
      await _loadScreenData();
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
      backgroundColor: const Color(0xFFFFE9E6),
      body: SafeArea(
        child: Column(
          children: [
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
                          builder: (context) => const HealthcenterNotif(),
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
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: _goToCreatePost,
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
                    if (controller.isLoadingPosts)
                      const Center(child: CircularProgressIndicator())
                    else if (controller.posts.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBC1CC),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: const Text(
                          'No posts yet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFE94E80),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: controller.posts.map((post) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _postCard(
                              centerName: centerName,
                              fullAddress: fullAddress,
                              title: (post['title'] ?? '').toString(),
                              category: (post['category'] ?? '').toString(),
                              description:
                                  (post['description'] ?? '').toString(),
                              createdAt: (post['created_at'] ?? '').toString(),
                            ),
                          );
                        }).toList(),
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
        border: borderOnly
            ? Border.all(color: const Color(0xFFE94E80))
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: borderOnly ? const Color(0xFFE94E80) : Colors.white,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: borderOnly ? const Color(0xFFE94E80) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _postCard({
    required String centerName,
    required String fullAddress,
    required String title,
    required String category,
    required String description,
    required String createdAt,
  }) {
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
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFE94E80),
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${centerName.trim().isEmpty ? 'HEALTH CENTER' : centerName.toUpperCase()}\n'
                  '${fullAddress.trim().isEmpty ? 'No address available' : fullAddress}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const Text(
                'EDIT INFO',
                style: TextStyle(
                  color: Color(0xFFE94E80),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '🍼 "$title"',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Category: $category',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE94E80),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 10),
          Text(
            'Posted on: $createdAt',
            style: const TextStyle(
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