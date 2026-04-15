//mother_editprof_controller.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MotherEditprofController {
  final SupabaseClient _client = Supabase.instance.client;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
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

  Map<String, String> splitFullName(String fullName) {
    final cleanName = fullName.trim();

    if (cleanName.isEmpty) {
      return {
        'first_name': '',
        'last_name': '',
      };
    }

    final parts = cleanName.split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return {
        'first_name': parts.first,
        'last_name': '',
      };
    }

    return {
      'first_name': parts.first,
      'last_name': parts.sublist(1).join(' '),
    };
  }

  String buildFullName() {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    final fullName = [firstName, lastName]
        .where((part) => part.isNotEmpty)
        .join(' ')
        .trim();

    return fullName.isEmpty ? 'Full name' : fullName;
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
        final fullNameParts = splitFullName(_safeText(profile['full_name']));

        usernameController.text = _safeText(profile['username']);
        firstNameController.text = fullNameParts['first_name'] ?? '';
        lastNameController.text = fullNameParts['last_name'] ?? '';
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

      final fullName = buildFullName();

      print('CURRENT LOGGED IN AUTH ID: ${user.id}');
      print('username: ${usernameController.text}');
      print('first name: ${firstNameController.text}');
      print('last name: ${lastNameController.text}');
      print('full name: $fullName');
      print('address: ${streetController.text}');

      final updatedRows = await _client
          .from('mothers')
          .update({
            'username': valueOrDefault(usernameController.text, 'Username'),
            'full_name': fullName,
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
      final fullNameParts = splitFullName(_safeText(updatedProfile['full_name']));

      usernameController.text = _safeText(updatedProfile['username']);
      firstNameController.text = fullNameParts['first_name'] ?? '';
      lastNameController.text = fullNameParts['last_name'] ?? '';
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
    firstNameController.dispose();
    lastNameController.dispose();
    streetController.dispose();
    barangayController.dispose();
    cityController.dispose();
  }
}