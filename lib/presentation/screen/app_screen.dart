import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaia_mobile_app/cubit/cubit/navbar_cubit.dart';
import 'package:kaia_mobile_app/presentation/screen/account_screen.dart';
import 'package:kaia_mobile_app/presentation/screen/home_screen.dart';
import 'package:kaia_mobile_app/presentation/screen/presence_screen.dart';
import 'package:kaia_mobile_app/utils/default_colors.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});


  final List<Widget> _widgetOptions = const [
    HomeScreen(),
    PresenceScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<NavbarCubit, int>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            body: _widgetOptions.elementAt(state),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_rounded),
                  label: 'Hasil Presensi',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Akun',
                ),
              ],
              currentIndex: state,
              selectedItemColor: kPrimary,
              onTap: (value) {
                context.read<NavbarCubit>().setIndex(value);
              },
            ),
          );
        },
      ),
    );
  }
}
