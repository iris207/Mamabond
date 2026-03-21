import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthcenterEditprofController {
  final SupabaseClient _client = Supabase.instance.client;

  final TextEditingController centerNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController barangayController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;

  String _safeText(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  Future<String?> loadHealthCenterProfile() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        isLoading = false;
        return 'No logged in user found';
      }

      print('CURRENT HEALTHCENTER AUTH ID: ${user.id}');

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

      if (profile != null) {
        centerNameController.text = _safeText(profile['center_name']);
        emailController.text = _safeText(profile['email']);
        contactNumberController.text = _safeText(profile['contact_number']);
        addressController.text = _safeText(profile['address']);
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
      return 'Failed to load health center profile';
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

      print('CURRENT HEALTHCENTER AUTH ID: ${user.id}');
      print('center_name: ${centerNameController.text}');
      print('contact_number: ${contactNumberController.text}');
      print('address: ${addressController.text}');

      final updatedRows = await _client
          .from('healthcenters')
          .update({
            'center_name': centerNameController.text.trim(),
            'contact_number': contactNumberController.text.trim(),
            'address': addressController.text.trim(),
          })
          .eq('auth_user_id', user.id)
          .select('''
            center_name,
            email,
            contact_number,
            address,
            barangay,
            city
          ''');

      isSaving = false;

      print('UPDATED ROWS: $updatedRows');

      if (updatedRows.isEmpty) {
        return {
          'success': false,
          'message': 'No matching health center profile found for this account',
        };
      }

      final updatedProfile = updatedRows.first;

      centerNameController.text = _safeText(updatedProfile['center_name']);
      emailController.text = _safeText(updatedProfile['email']);
      contactNumberController.text = _safeText(updatedProfile['contact_number']);
      addressController.text = _safeText(updatedProfile['address']);
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
    centerNameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    addressController.dispose();
    barangayController.dispose();
    cityController.dispose();
  }
}