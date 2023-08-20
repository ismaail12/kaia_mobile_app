import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaia_mobile_app/bloc/auth/auth_bloc.dart';
import 'package:kaia_mobile_app/bloc/bloc/device_bloc.dart';
import 'package:kaia_mobile_app/presentation/screen/change_pass.dart';
import 'package:kaia_mobile_app/presentation/screen/login_screen.dart';
import 'package:kaia_mobile_app/utils/custom_utils.dart';
import 'package:kaia_mobile_app/utils/default_colors.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isActivated = false;

  @override
  Widget build(BuildContext context) {
    context.read<DeviceBloc>().add(const GetPhone());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text("Pengaturan Akun",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            //konfigurasi akun
            const SizedBox(
              height: 16 * 2,
            ),
            BlocBuilder<DeviceBloc, DeviceState>(
              builder: (context, state) {

                return ListTile(
                    onTap: () {

                      if (state is DeviceLoading) {
                         Container();
                      }

                      if (state is DeviceHasRegistered) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title:  const Text("Perangkat tidak aktif"),
                              content:  const Text("Anda sudah mendaftarkan perangkat, namun perangkat yang anda gunakan tidak terdaftar. jika ingin melakukan perubahan silagkan hubungi admin"),
                              actions: [
                                TextButton(
                                  child:  const Text('Ok'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      if (state is DeviceNotActive) {
                        CustomUtils.customAlertConfirmDialog(
                          context,
                          () async {

                            final androidInfo = await CustomUtils.getInfo();

                            if (!mounted) return;
                            context
                                .read<DeviceBloc>()
                                .add(UpdatePhone(androidInfo.id));
                          },
                          message:
                              'Daftarkan perangkat ini sebagai perangkat yang digunakan untuk melakukan presensi?',
                          title: 'Aktivasi Perangkat',
                        );
                      } 
                        
                      if (state is DeviceActive) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title:  const Text("Perangkat Sudah Terdaftar"),
                              content:  const Text("Perangkat sudah terdaftar, jika ingin melakukan perubahan silagkan hubungi admin"),
                              actions: [
                                TextButton(
                                  child:  const Text('Ok'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    leading: const Icon(Icons.phone_android, color: kPrimary),
                    title: const Text(
                      'Aktivasi Perangkat',
                    ),
                    trailing: Chip(
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      backgroundColor: state is DeviceActive
                          ? Colors.green[100]
                          : Colors.red[100],
                      label: Text(
                        state is DeviceActive
                            ? 'Sudah Aktif'
                            : 'Perangkat tidak aktif',
                        style: TextStyle(
                            color: state is DeviceActive
                                ? Colors.green
                                : Colors.red,
                            fontSize: 12),
                      ),
                    ));
              },
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ChangePassword(),
                    ));
              },
              child: const ListTile(
                leading: Icon(Icons.key, color: kPrimary),
                title: Text('Update Password'),
                trailing: Icon(Icons.navigate_next),
              ),
            ),

            //tentang aplikasi
            InkWell(
              onTap: () {
                showMessageDialog(context,
                    "Aplikasi dibuat untuk memenuhi tugas akhir skripsi Teknik Informatika Universitas Pamulang");
              },
              child: const ListTile(
                leading: Icon(Icons.info, color: kPrimary),
                title: Text('Tentang Aplikasi'),
                trailing: Icon(Icons.navigate_next),
              ),
            ),
            InkWell(
              onTap: () {
                showMessageDialog(context,
                    "Jika ada pertannyaan atau kendala bisa 08994580581");
              },
              child: const ListTile(
                leading: Icon(Icons.question_answer, color: kPrimary),
                title: Text('Bantuan'),
                trailing: Icon(Icons.navigate_next),
              ),
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                // if (state.status == AuthStatus.onLogin) {
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //       builder: (BuildContext context) => LoginScreen(),
                //     ),
                //   );
                // }
              },
              child: InkWell(
                onTap: () {
                  CustomUtils.customAlertConfirmDialog(
                    context,
                    () {
                      final token = context.read<AuthBloc>().state.token;
                      context.read<AuthBloc>().add(AuthLogout(token!));
                    },
                    title: 'Konfirmasi',
                    message: 'Yakin keluar?',
                  );
                },
                child: ListTile(
                  leading: const Icon(Icons.door_front_door, color: kPrimary),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.red[500]),
                  ),
                  trailing: const Icon(Icons.navigate_next),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showMessageDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
