import '../controllers/auth_controller.dart';

class RegisterController {
  final AuthController _authController = AuthController();

  Future<String?> registerMother({
    required String fullName,
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
      fullName: fullName,
      address: address,
      city: city,
      barangay: barangay,
    );

    if (result['success'] == true) {
      return null;
    } else {
      return result['message'];
    }
  }
}