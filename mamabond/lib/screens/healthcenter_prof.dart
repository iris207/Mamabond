import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/screens/healthcenter_notif.dart';
import 'package:mamabond/screens/healthcenter_editprof.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthCenterProfileScreen extends StatefulWidget {
  const HealthCenterProfileScreen({super.key});

  @override
  State<HealthCenterProfileScreen> createState() =>
      _HealthCenterProfileScreenState();
}

class _HealthCenterProfileScreenState extends State<HealthCenterProfileScreen> {
  final SupabaseClient _client = Supabase.instance.client;

  bool isLoading = true;

  String centerName = '';
  String email = '';
  String contactNumber = '';
  String address = '';
  String barangay = '';
  String city = '';

  @override
  void initState() {
    super.initState();
    _loadHealthCenterProfile();
  }

  String _safeText(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  Future<void> _loadHealthCenterProfile() async {
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
          .from('healthcenters')
          .select('''
            center_name,
            email,
            contact_number,
            address,
            barangay,
            city
          ''')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      if (!mounted) return;

      if (profile != null) {
        setState(() {
          centerName = _safeText(profile['center_name']);
          email = _safeText(profile['email']);
          contactNumber = _safeText(profile['contact_number']);
          address = _safeText(profile['address']);
          barangay = _safeText(profile['barangay']);
          city = _safeText(profile['city']);
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
      backgroundColor: const Color(0xFFF7EFE8),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    height: 62,
                    color: const Color(0xFFF7C9D3),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/logo.notext.png",
                          width: 42,
                          height: 42,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "MamaBond",
                            style: GoogleFonts.lobster(
                              fontSize: 30,
                              color: const Color(0xFFE85A8B),
                            ),
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
                                  ),
                                  child: const Icon(
                                    Icons.local_hospital,
                                    size: 62,
                                    color: Color(0xFFE85A8B),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  centerName.trim().isEmpty
                                      ? 'HEALTH CENTER'
                                      : centerName.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE85A8B),
                                  ),
                                ),
                                const SizedBox(height: 4),
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
                                const SizedBox(height: 2),
                                Text(
                                  email.trim().isEmpty ? 'No email' : email,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFE88AA5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  contactNumber.trim().isEmpty
                                      ? 'No contact number'
                                      : contactNumber,
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
                                              const HealthCenterEditProf(),
                                        ),
                                      );

                                      if (updated == true) {
                                        await _loadHealthCenterProfile();
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
                          const SizedBox(height: 18),
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
                          const SizedBox(height: 10),
                          _HealthCenterPostCard(
                            centerName: centerName,
                            fullAddress: fullAddress,
                          ),
                          const SizedBox(height: 18),
                          _HealthCenterPostCard(
                            centerName: centerName,
                            fullAddress: fullAddress,
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
}

class _HealthCenterPostCard extends StatelessWidget {
  final String centerName;
  final String fullAddress;

  const _HealthCenterPostCard({
    required this.centerName,
    required this.fullAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4D0D7),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFF8E8EC),
                child: Icon(
                  Icons.account_circle_outlined,
                  color: Color(0xFFE85A8B),
                  size: 30,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      centerName.trim().isEmpty
                          ? 'HEALTH CENTER'
                          : centerName.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFFE85A8B),
                      ),
                    ),
                    Text(
                      fullAddress.isEmpty ? 'No address available' : fullAddress,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE88AA5),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: const [
                  Text(
                    "EDIT INFO",
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
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDAEBB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '🍼 “How to Store Breast Milk Properly”',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFFFFF2F5),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Summary: “A quick guide on proper storage methods for expressed milk, including room temp, refrigeration, and freezing times.”',
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
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  "👁 Views: 215",
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
                  "💬 Comments: 0",
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