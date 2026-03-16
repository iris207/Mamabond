import '../controllers/auth_controller.dart';

class RegisterController {
  final AuthController _authController = AuthController();

  Future<String?> registerMother({
    required String email,
    required String password,
    required String username,
    required String address,
    required String city,
    required String barangay,
  }) async {
    final result = await _authController.registerMother(
      username: username,
      email: email,
      password: password,
      fullName: username, // You can change this later if needed
      barangay: barangay,
    );

    if (result['success'] == true) {
      return null; // success
    } else {
      return result['message'];
    }
  }
}