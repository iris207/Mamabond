import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // =========================
  // REGISTER MOTHER
  // =========================
  Future<Map<String, dynamic>> registerMother({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String barangay,
  }) async {
    try {
      // STEP 1: Create user in auth.users
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return {
          'success': false,
          'message': 'Registration failed',
        };
      }

      final userId = response.user!.id;

      // STEP 2: Insert profile into mothers table
      await _supabase.from('mothers').insert({
        'auth_user_id': userId,
        'username': username,
        'email': email,
        'full_name': fullName,
        'barangay': barangay,
      });

      return {
        'success': true,
        'message': 'Mother registered successfully',
      };
    } on AuthException catch (e) {
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
  // =========================
// REGISTER HEALTH CENTER
// =========================
Future<Map<String, dynamic>> registerHealthCenter({
  required String centerName,
  required String email,
  required String password,
  required String address,
  required String barangay,
}) async {
  try {
    // STEP 1: Create auth user
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      return {
        'success': false,
        'message': 'Registration failed',
      };
    }

    final userId = response.user!.id;

    // STEP 2: Insert into healthcenters table
    await _supabase.from('healthcenters').insert({
      'auth_user_id': userId,
      'center_name': centerName,
      'email': email,
      'address': address,
      'barangay': barangay,
    });

    return {
      'success': true,
      'message': 'Health center registered successfully',
    };
  } on AuthException catch (e) {
    return {
      'success': false,
      'message': e.message,
    };
  } catch (e) {
    return {
      'success': false,
      'message': e.toString(),
    };
  }
}
// =========================
// LOGIN (USERNAME OR EMAIL)
// =========================
Future<Map<String, dynamic>> login({
  required String usernameOrEmail,
  required String password,
}) async {
  try {
    String? email;

    // STEP 1: Determine if input is email
    if (usernameOrEmail.contains('@')) {
      email = usernameOrEmail;
    } else {
      // Try to find mother by username
      final mother = await _supabase
          .from('mothers')
          .select('email')
          .eq('username', usernameOrEmail)
          .maybeSingle();

      if (mother != null) {
        email = mother['email'];
      } else {
        // Try health center
        final center = await _supabase
            .from('healthcenters')
            .select('email')
            .eq('center_name', usernameOrEmail)
            .maybeSingle();

        if (center != null) {
          email = center['email'];
        }
      }
    }

    if (email == null) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    // STEP 2: Login using email
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      return {
        'success': false,
        'message': 'Login failed',
      };
    }

    final userId = response.user!.id;

    // STEP 3: Detect role
    final motherProfile = await _supabase
        .from('mothers')
        .select()
        .eq('auth_user_id', userId)
        .maybeSingle();

    if (motherProfile != null) {
      return {
        'success': true,
        'userType': 'MOTHER',
        'data': motherProfile,
      };
    }

    final centerProfile = await _supabase
        .from('healthcenters')
        .select()
        .eq('auth_user_id', userId)
        .maybeSingle();

    if (centerProfile != null) {
      return {
        'success': true,
        'userType': 'HEALTHCENTER',
        'data': centerProfile,
      };
    }

    return {
      'success': false,
      'message': 'Profile not found',
    };
  } on AuthException catch (e) {
    return {
      'success': false,
      'message': e.message,
    };
  } catch (e) {
    return {
      'success': false,
      'message': e.toString(),
    };
  }
}
}