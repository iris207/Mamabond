import 'auth_controller.dart';

class HealthcenterRegisController {
  final AuthController _authController = AuthController();

  Future<String?> registerHealthCenter({
    required String email,
    required String password,
    required String centerName,
    required String address,
    required String city,
    required String barangay,
    required String contactNumber,
  }) async {
    final result = await _authController.registerHealthCenter(
      centerName: centerName,
      email: email,
      password: password,
      address: address,
      barangay: barangay,
      city: city,
      contactNumber: contactNumber,
    );

    if (result['success'] == true) {
      return null;
    } else {
      return result['message'];
    }
  }
}