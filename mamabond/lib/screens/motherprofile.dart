import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/screens/mothernotif.dart';
import 'package:mamabond/screens/mother_editprof.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MotherProfileScreen extends StatefulWidget {
  const MotherProfileScreen({super.key});

  @override
  State<MotherProfileScreen> createState() => _MotherProfileScreenState();
}

class _MotherProfileScreenState extends State<MotherProfileScreen> {
  final SupabaseClient _client = Supabase.instance.client;

  bool isLoading = true;

  String fullName = '';
  String address = '';
  String barangay = '';
  String city = '';
  String username = '';
  String? profilePic;

  @override
  void initState() {
    super.initState();
    _loadMotherProfile();
  }

  String _safeText(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  Future<void> _loadMotherProfile() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      setState(() {
        isLoading = true;
      });

      final profile = await _client
          .from('mothers')
          .select('''
            username,
            full_name,
            address,
            barangay,
            city,
            mother_prof_pic
          ''')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      if (!mounted) return;

      if (profile != null) {
        setState(() {
          username = _safeText(profile['username']);
          fullName = _safeText(profile['full_name']);
          address = _safeText(profile['address']);
          barangay = _safeText(profile['barangay']);
          city = _safeText(profile['city']);
          profilePic = profile['mother_prof_pic'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  String get fullAddress {
    final parts = [address, barangay, city]
        .where((part) => part.trim().isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EEE8),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    height: 62,
                    color: const Color(0xFFF7C9D3),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/logo.notext.png",
                          width: 38,
                          height: 38,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "MamaBond",
                            style: GoogleFonts.lobster(
                              fontSize: 28,
                              color: const Color(0xFFE85A8B),
                            ),
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
                            color: Color(0xFFE85A8B),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF0C7CF),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(26),
                                bottomRight: Radius.circular(26),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFE85A8B),
                                      width: 3,
                                    ),
                                    color: const Color(0xFFF6D7DE),
                                    image: profilePic != null &&
                                            profilePic!.trim().isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(profilePic!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: (profilePic == null ||
                                          profilePic!.trim().isEmpty)
                                      ? const Icon(
                                          Icons.person,
                                          size: 68,
                                          color: Color(0xFFE85A8B),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  username.trim().isEmpty
                                      ? 'No username'
                                      : username,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE85A8B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  fullName.trim().isEmpty
                                      ? 'No name available'
                                      : fullName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFE88AA5),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  fullAddress.isEmpty
                                      ? 'No address available'
                                      : fullAddress,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFE88AA5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 28,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final updated = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MotherEditprof(),
                                        ),
                                      );

                                      if (updated == true) {
                                        await _loadMotherProfile();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEE6D98),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Text(
                                      "EDIT INFO",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "YOUR POSTS:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Color(0xFFE85A8B),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const _MotherPostCard(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _MotherPostCard extends StatelessWidget {
  const _MotherPostCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4D0D7),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFF8E8EC),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFFE85A8B),
                      size: 22,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Mary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFFE85A8B),
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Text(
                    "EDIT POST",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFE88AA5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.edit_outlined,
                    color: Color(0xFFE88AA5),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDAEBB),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '“How to Store Breast Milk Properly”',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFFFFF2F5),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Summary: "A quick guide on proper storage methods for expressed milk, including room temp, refrigeration, and freezing times."',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFFFF2F5),
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Posted on: July 29, 2025",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFFFCE2E8),
                      ),
                    ),
                    Text(
                      "see more ...",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFFFCE2E8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  "LIKE : 215",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE85A8B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "|",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE85A8B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Comment: 0",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE85A8B),
                    fontWeight: FontWeight.bold,
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