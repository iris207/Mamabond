import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthcenterPostController {
  final SupabaseClient _client = Supabase.instance.client;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isPosting = false;
  bool isLoadingPosts = true;

  List<Map<String, dynamic>> posts = [];

  String valueOrDefault(String value, String fallback) {
    return value.trim().isEmpty ? fallback : value.trim();
  }

  Future<Map<String, dynamic>> createPost() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        return {
          'success': false,
          'message': 'No logged in user found',
        };
      }

      isPosting = true;

      final healthcenter = await _client
          .from('healthcenters')
          .select('id, barangay')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      if (healthcenter == null) {
        isPosting = false;
        return {
          'success': false,
          'message': 'Health center profile not found',
        };
      }

      final healthcenterId = healthcenter['id'];
      final barangay = healthcenter['barangay'];

      await _client.from('healthcenter_posts').insert({
        'healthcenter_id': healthcenterId,
        'barangay': barangay,
        'title': valueOrDefault(titleController.text, 'No title'),
        'category': valueOrDefault(categoryController.text, 'No category'),
        'description': valueOrDefault(
          descriptionController.text,
          'No description',
        ),
      });

      isPosting = false;

      titleController.clear();
      categoryController.clear();
      descriptionController.clear();

      return {
        'success': true,
        'message': 'Post created successfully',
      };
    } on PostgrestException catch (e) {
      isPosting = false;
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      isPosting = false;
      return {
        'success': false,
        'message': 'Something went wrong: $e',
      };
    }
  }

  Future<String?> loadMyPosts() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        isLoadingPosts = false;
        return 'No logged in user found';
      }

      final healthcenter = await _client
          .from('healthcenters')
          .select('id')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      if (healthcenter == null) {
        isLoadingPosts = false;
        return 'Health center profile not found';
      }

      final healthcenterId = healthcenter['id'];

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
          .eq('healthcenter_id', healthcenterId)
          .order('created_at', ascending: false);

      posts = List<Map<String, dynamic>>.from(result);
      isLoadingPosts = false;
      return null;
    } on PostgrestException catch (e) {
      isLoadingPosts = false;
      return e.message;
    } catch (e) {
      isLoadingPosts = false;
      return 'Failed to load posts';
    }
  }

  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
  }
}