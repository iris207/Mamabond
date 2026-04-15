import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/controllers/mother_home_posts_controller.dart';
import 'motherpost.dart';
import 'package:mamabond/screens/healthcenterview.dart';
import 'package:mamabond/screens/mothernotif.dart';
import 'package:mamabond/screens/motherprofile.dart';
import 'package:mamabond/screens/milkbank_locator.dart';
import 'package:mamabond/screens/bf_station_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MotherHomePostsController controller = MotherHomePostsController();
  final SupabaseClient _client = Supabase.instance.client;

  String motherBarangay = '';

  @override
  void initState() {
    super.initState();
    _loadScreenData();
  }

  Future<void> _loadScreenData() async {
    await _loadMotherInfo();
    final error = await controller.loadPostsForMother();

    if (!mounted) return;

    setState(() {});

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  Future<void> _loadMotherInfo() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) return;

      final mother = await _client
          .from('mothers')
          .select('barangay')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      if (mother != null) {
        motherBarangay = (mother['barangay'] ?? '').toString();
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE9E6),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
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
                                      Icon(
                                        Icons.add,
                                        size: 26,
                                        color: Colors.white,
                                      ),
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
                                                Icon(
                                                  Icons.local_hospital,
                                                  size: 22,
                                                  color: Colors.white,
                                                ),
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
                                              color: const Color(0xFFF25A88),
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.person,
                                                  size: 22,
                                                  color: Colors.white,
                                                ),
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
                        if (controller.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (controller.posts.isEmpty)
                          _emptyPostCard(motherBarangay: motherBarangay)
                        else
                          Column(
                            children: controller.posts.map((post) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 18),
                                child: _postCard(
                                  title: (post['title'] ?? '').toString(),
                                  category: (post['category'] ?? '').toString(),
                                  description:
                                      (post['description'] ?? '').toString(),
                                  barangay: (post['barangay'] ?? '').toString(),
                                  createdAt:
                                      (post['created_at'] ?? '').toString(),
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
        ],
      ),
    );
  }

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

  static Widget _emptyPostCard({
    required String motherBarangay,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF3D3D8),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFB98B96),
          width: 1.5,
        ),
      ),
      child: Text(
        motherBarangay.trim().isEmpty
            ? 'No posts available'
            : 'No posts available for $motherBarangay yet',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFE94E80),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Widget _postCard({
    required String title,
    required String category,
    required String description,
    required String barangay,
    required String createdAt,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3D3D8),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFB98B96),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFE85A8B),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HEALTH CENTER',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE85A8B),
                      ),
                    ),
                    Text(
                      'Same barangay post',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFE88AA5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFB0BC),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🍼 "$title"',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Category: $category',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE85A8B),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Summary: $description',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Barangay: $barangay',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Posted on: $createdAt',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Likes : 0',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE85A8B),
                ),
              ),
              Text(
                '|',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE85A8B),
                ),
              ),
              Text(
                'Comments: 0',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE85A8B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}