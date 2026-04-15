import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthCenterViewProfileScreen extends StatefulWidget {
  const HealthCenterViewProfileScreen({super.key});

  @override
  State<HealthCenterViewProfileScreen> createState() =>
      _HealthCenterViewProfileScreenState();
}

class _HealthCenterViewProfileScreenState
    extends State<HealthCenterViewProfileScreen> {
  final SupabaseClient _client = Supabase.instance.client;

  bool isLoading = true;

  String motherBarangay = '';
  List<Map<String, dynamic>> healthCenters = [];

  @override
  void initState() {
    super.initState();
    _loadSameBarangayHealthCenters();
  }

  String _safeText(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  Future<void> _loadSameBarangayHealthCenters() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final mother = await _client
          .from('mothers')
          .select('barangay')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      if (mother == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final barangay = _safeText(mother['barangay']);

      final centers = await _client
          .from('healthcenters')
          .select('''
            id,
            center_name,
            address,
            barangay,
            city
          ''')
          .eq('barangay', barangay)
          .order('center_name', ascending: true);

      final centersList = List<Map<String, dynamic>>.from(centers);

      for (int i = 0; i < centersList.length; i++) {
        final centerId = centersList[i]['id'];

        final posts = await _client
            .from('healthcenter_posts')
            .select('''
              id,
              title,
              category,
              description,
              photo_url,
              created_at
            ''')
            .eq('healthcenter_id', centerId)
            .order('created_at', ascending: false);

        centersList[i]['posts'] = List<Map<String, dynamic>>.from(posts);
      }

      if (!mounted) return;

      setState(() {
        motherBarangay = barangay;
        healthCenters = centersList;
        isLoading = false;
      });
    } on PostgrestException catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load health centers')),
      );
    }
  }

  String _fullAddress(Map<String, dynamic> center) {
    final address = _safeText(center['address']);
    final barangay = _safeText(center['barangay']);
    final city = _safeText(center['city']);

    final parts = [address, barangay, city]
        .where((part) => part.trim().isNotEmpty)
        .toList();

    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDB7BC),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                    if (healthCenters.isEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7B5BC),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          motherBarangay.trim().isEmpty
                              ? 'No health centers found'
                              : 'No health centers found for $motherBarangay',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFE94E80),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: healthCenters.map((center) {
                          final centerName = _safeText(center['center_name']);
                          final fullAddress = _fullAddress(center);
                          final posts =
                              List<Map<String, dynamic>>.from(center['posts'] ?? []);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Column(
                              children: [
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
                                        radius: 45,
                                        backgroundColor: Color(0xFFE94E80),
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        centerName.trim().isEmpty
                                            ? 'HEALTH CENTER'
                                            : centerName.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFE94E80),
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        fullAddress.isEmpty
                                            ? 'No address available'
                                            : fullAddress,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Color(0xFFE94E80),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                if (posts.isEmpty)
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFBC1CC),
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'No posts yet',
                                        style: TextStyle(
                                          color: Color(0xFFE94E80),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Column(
                                    children: posts.map((post) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: _postCard(
                                          centerName: centerName,
                                          fullAddress: fullAddress,
                                          title: _safeText(post['title']),
                                          category: _safeText(post['category']),
                                          description:
                                              _safeText(post['description']),
                                          createdAt:
                                              _safeText(post['created_at']),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE89AA8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🍼 "$title"',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Category: $category',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE94E80),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Summary: $description',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  "Posted on: $createdAt",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
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