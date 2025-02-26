import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wastewise/app/common/widgets/polka_dot_background.dart';
import '../controllers/register_controller.dart';
import '../../../common/theme/app_theme.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final regC = Get.find<RegisterController>();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      // Agar area Scaffold transparan (gradient + polka dot terlihat)
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.greenLight,
                  AppTheme.greenDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Polka Dot Animation (GetX)
          const PolkaDotBackground(),

          // Form di tengah
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(24.0),
                padding: const EdgeInsets.symmetric(
                  vertical: 32.0,
                  horizontal: 24.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ========== LOGO WASTEWISE ==========
                      Image.asset(
                        'assets/icons/wastewise_logo.png',
                        height: 200,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nama Lengkap
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap',
                          prefixIcon: Icon(Icons.person, color: AppTheme.primaryGreen),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => regC.fullName.value = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Masukkan nama lengkap'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Username
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.account_circle, color: AppTheme.primaryGreen),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => regC.username.value = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Masukkan username'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Tanggal Lahir
                      Obx(
                            () => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.cake, color: AppTheme.primaryGreen),
                          title: Text(
                            regC.dateOfBirth.value != null
                                ? '${regC.dateOfBirth.value!.day}/'
                                '${regC.dateOfBirth.value!.month}/'
                                '${regC.dateOfBirth.value!.year}'
                                : 'Pilih tanggal lahir',
                          ),
                          onTap: () async {
                            DateTime initialDate =
                                regC.dateOfBirth.value ?? DateTime(2000, 1, 1);
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              regC.dateOfBirth.value = pickedDate;
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Email (untuk register manual)
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: AppTheme.primaryGreen),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => regC.email.value = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Masukkan email'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock, color: AppTheme.primaryGreen),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        onChanged: (val) => regC.password.value = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Masukkan password'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock_outline, color: AppTheme.primaryGreen),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        onChanged: (val) => regC.confirmPassword.value = val,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Masukkan konfirmasi password';
                          }
                          if (val != regC.password.value) {
                            return 'Password tidak sama';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),


                      // Tombol Register (Email & Password)
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (regC.dateOfBirth.value == null) {
                              Get.snackbar('Error', 'Pilih tanggal lahir');
                              return;
                            }
                            regC.register();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.greenDark,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 24.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // =========== TOMBOL REGISTER WITH GOOGLE ===========
                      ElevatedButton.icon(
                        onPressed: () {
                          // Validasi minimal input fullName & username
                          if (regC.fullName.value.isEmpty ||
                              regC.username.value.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Masukkan nama lengkap dan username.',
                            );
                            return;
                          }
                          if (regC.dateOfBirth.value == null) {
                            Get.snackbar('Error', 'Pilih tanggal lahir');
                            return;
                          }
                          regC.registerWithGoogle();
                        },
                        icon: Image.asset(
                          'assets/icons/google_logo.png', // Pastikan ada
                          height: 24,
                        ),
                        label: const Text('Register with Google'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 24.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      // =========== END REGISTER WITH GOOGLE ===========

                      const SizedBox(height: 16),

                      // Link ke Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sudah punya akun?",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => regC.navigateToLogin(),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: AppTheme.greenDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
