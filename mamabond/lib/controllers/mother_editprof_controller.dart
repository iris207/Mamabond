import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MotherEditprofController {
  final SupabaseClient _client = Supabase.instance.client;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController barangayController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;

  String _safeText(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  String valueOrDefault(String value, String fallback) {
    return value.trim().isEmpty ? fallback : value.trim();
  }

  Future<String?> loadMotherProfile() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        isLoading = false;
        return 'No logged in user found';
      }

      print('LOAD PROFILE AUTH ID: ${user.id}');

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

      if (profile != null) {
        usernameController.text = _safeText(profile['username']);
        fullNameController.text = _safeText(profile['full_name']);
        streetController.text = _safeText(profile['address']);
        barangayController.text = _safeText(profile['barangay']);
        cityController.text = _safeText(profile['city']);
      }

      isLoading = false;
      return null;
    } on PostgrestException catch (e) {
      isLoading = false;
      return e.message;
    } catch (e) {
      isLoading = false;
      return 'Failed to load profile';
    }
  }

  Future<Map<String, dynamic>> saveProfile() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        return {
          'success': false,
          'message': 'User not found',
        };
      }

      isSaving = true;

      print('CURRENT LOGGED IN AUTH ID: ${user.id}');
      print('username: ${usernameController.text}');
      print('full name: ${fullNameController.text}');
      print('address: ${streetController.text}');

      final updatedRows = await _client
          .from('mothers')
          .update({
            'username': valueOrDefault(usernameController.text, 'Username'),
            'full_name': valueOrDefault(fullNameController.text, 'Full name'),
            'address': valueOrDefault(streetController.text, 'Address'),
          })
          .eq('auth_user_id', user.id)
          .select('''
            username,
            full_name,
            address,
            barangay,
            city,
            mother_prof_pic
          ''');

      isSaving = false;

      print('UPDATED ROWS: $updatedRows');

      if (updatedRows.isEmpty) {
        return {
          'success': false,
          'message': 'No matching mother profile found for this logged-in account',
        };
      }

      final updatedProfile = updatedRows.first;

      usernameController.text = _safeText(updatedProfile['username']);
      fullNameController.text = _safeText(updatedProfile['full_name']);
      streetController.text = _safeText(updatedProfile['address']);
      barangayController.text = _safeText(updatedProfile['barangay']);
      cityController.text = _safeText(updatedProfile['city']);

      return {
        'success': true,
        'message': 'Profile updated successfully',
        'data': updatedProfile,
      };
    } on PostgrestException catch (e) {
      isSaving = false;
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      isSaving = false;
      return {
        'success': false,
        'message': 'Something went wrong while saving: $e',
      };
    }
  }

  Future<Map<String, dynamic>> signOut() async {
    try {
      await _client.auth.signOut();
      return {
        'success': true,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to sign out',
      };
    }
  }

  void dispose() {
    usernameController.dispose();
    fullNameController.dispose();
    streetController.dispose();
    barangayController.dispose();
    cityController.dispose();
  }
}