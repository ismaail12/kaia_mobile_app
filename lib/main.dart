import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kaia_mobile_app/bloc/app_bloc_observer.dart';
import 'package:kaia_mobile_app/bloc/auth/auth_bloc.dart';
import 'package:kaia_mobile_app/bloc/bloc/device_bloc.dart';
import 'package:kaia_mobile_app/bloc/internet/internet_bloc.dart';
import 'package:kaia_mobile_app/bloc/presence/presence_bloc.dart';
import 'package:kaia_mobile_app/cubit/cubit/navbar_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaia_mobile_app/cubit/cubit/type_chip_cubit.dart';
import 'package:kaia_mobile_app/presentation/screen/splash_screen.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavbarCubit>(
          create: (context) => NavbarCubit(),
        ),
        BlocProvider<TypeChipCubit>(
          create: (context) => TypeChipCubit(),
        ),
        BlocProvider<InternetBloc>(
          create: (context) => InternetBloc(),
        ),
        BlocProvider<DeviceBloc>(
          create: (context) => DeviceBloc(),
        ),
        BlocProvider<PresenceBloc>(
          create: (context) => PresenceBloc(internetBloc: context.read<InternetBloc>())..add(PresenceInitial()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(internetBloc: context.read<InternetBloc>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: const SplashScreen(),
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }
}
