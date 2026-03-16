import '../service/auth.dart';

class AuthController {
  final AuthService _authService = AuthService();

  // REGISTER MOTHER
  Future<Map<String, dynamic>> registerMother({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String barangay,
  }) async {
    return await _authService.registerMother(
      username: username,
      email: email,
      password: password,
      fullName: fullName,
      barangay: barangay,
    );
  }

  // REGISTER HEALTH CENTER
  Future<Map<String, dynamic>> registerHealthCenter({
    required String centerName,
    required String email,
    required String password,
    required String address,
    required String barangay,
  }) async {
    return await _authService.registerHealthCenter(
      centerName: centerName,
      email: email,
      password: password,
      address: address,
      barangay: barangay,
    );
  }

  // LOGIN
  Future<Map<String, dynamic>> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    return await _authService.login(
      usernameOrEmail: usernameOrEmail,
      password: password,
    );
  }
}