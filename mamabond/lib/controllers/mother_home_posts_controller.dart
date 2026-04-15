import 'package:supabase_flutter/supabase_flutter.dart';

class MotherHomePostsController {
  final SupabaseClient _client = Supabase.instance.client;

  bool isLoading = true;
  List<Map<String, dynamic>> posts = [];

  Future<String?> loadPostsForMother() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        isLoading = false;
        return 'No logged in user found';
      }

      final mother = await _client
          .from('mothers')
          .select('barangay')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      if (mother == null) {
        isLoading = false;
        return 'Mother profile not found';
      }

      final motherBarangay = (mother['barangay'] ?? '').toString();

      final result = await _client
          .from('healthcenter_posts')
          .select('''
            id,
            healthcenter_id,
            barangay,
            title,
            category,
            description,
            photo_url,
            created_at
          ''')
          .eq('barangay', motherBarangay)
          .order('created_at', ascending: false);

      posts = List<Map<String, dynamic>>.from(result);
      isLoading = false;
      return null;
    } on PostgrestException catch (e) {
      isLoading = false;
      return e.message;
    } catch (e) {
      isLoading = false;
      return 'Failed to load posts';
    }
  }
}