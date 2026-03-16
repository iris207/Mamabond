import 'auth_controller.dart';

class HealthcenterRegisController{
  final AuthController _authController = AuthController();

  Future<String?> registerHealthCenter({
    required String email,
    required String password,
    required String centerName,
    required String city,
    required String barangay,
    required String contactNumber,
  }) async {
    final result = await _authController.registerHealthCenter(
      centerName: centerName,
      email: email,
      password: password,
      address: city, // adjust later if needed
      barangay: barangay,
    );

    if (result['success'] == true) {
      return null;
    } else {
      return result['message'];
    }
  }
}