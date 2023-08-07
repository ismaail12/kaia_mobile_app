import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaia_mobile_app/bloc/auth/auth_bloc.dart';
import 'package:kaia_mobile_app/presentation/components/custom_loading.dart';
import 'package:kaia_mobile_app/presentation/components/custom_textfield.dart';
import 'package:kaia_mobile_app/presentation/screen/app_screen.dart';
import 'package:kaia_mobile_app/utils/custom_utils.dart';
import 'package:kaia_mobile_app/utils/default_colors.dart';

import '../components/custom_button.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  final oldPasswordKey = GlobalKey<CusTextFieldState>();
  final newPasswordKey = GlobalKey<CusTextFieldState>();
  final confirmpasswordKey = GlobalKey<CusTextFieldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, // Ganti dengan warna yang diinginkan
        ),
        centerTitle: true,
        title: Text(
          'Ubah Password',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 16 * 5, left: 16, right: 16, top: 0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16 * 3),
                const Text(
                  'Password Anda harus minimal 6 karakter dan harus mencakup kombinasi angka, huruf, dan karakter khusus',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16 * 3),
                CusTextField(
                  key: oldPasswordKey,
                  isObsecure: true,
                  name: 'Password Sekarang',
                ),
                const SizedBox(height: 16),
                CusTextField(
                  key: newPasswordKey,
                  isObsecure: true,
                  name: 'Password Baru',
                ),
                const SizedBox(height: 16),
                CusTextField(
                  key: confirmpasswordKey,
                  isObsecure: true,
                  name: 'Konfirmasi Password Baru ',
                ),
                const SizedBox(height: 16 * 1.5),
                CusElevatedButton(
                    text: const Text('Ganti Password'), action: () {}),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
