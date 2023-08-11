import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kaia_mobile_app/bloc/internet/internet_bloc.dart';

import 'package:kaia_mobile_app/data/repository/presence_repository.dart';
import 'package:kaia_mobile_app/data/request/clockin_request.dart';
import 'package:kaia_mobile_app/data/request/clockout_request.dart';
import 'package:kaia_mobile_app/data/response/last5_response.dart';
import 'package:kaia_mobile_app/data/response/offlocs_response.dart';
import 'package:kaia_mobile_app/utils/constant.dart';
import 'package:kaia_mobile_app/utils/custom_utils.dart';
import 'package:kaia_mobile_app/utils/internet.dart';
import 'package:kaia_mobile_app/utils/presences_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'presence_event.dart';
part 'presence_state.dart';

class PresenceBloc extends HydratedBloc<PresenceEvent, PresenceState> {
  PresenceRepository presenceRepository = PresenceRepository();
  final InternetBloc internetBloc;
  String? token;
  late final StreamSubscription internetSubscription;
  bool internetConnection = false;
  bool isPhoneActivated = true;

  PresenceBloc({required this.internetBloc})
      : super(PresenceState(status: ClockedStatus.initial)) {
    on<PresenceInitial>(_onPresenceInitial);
    on<PresenceClockIn>(_onPresenceClockIn);
    on<PresenceClockOut>(_onPresenceClockOut);

    checkInternetConnection();
    getToken();
    internetSubscription =
        internetBloc.stream.listen((InternetState internetState) {
      internetState is Connected
          ? internetConnection = true
          : internetConnection = false;
    });
  }

  Future<void> getToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
  }

  Future<void> checkInternetConnection() async {
    internetConnection = await getInternetConnection();
  }

  void _onPresenceInitial(
      PresenceInitial event, Emitter<PresenceState> emit) async {
    final response = await presenceRepository.getLast5presences();

    response.fold((l) {}, (right) {
      final entry = right.data.entries.first.value;
      final status = entry.clockout == null
          ? ClockedStatus.clockedIn
          : ClockedStatus.initial;

      emit(PresenceState(
        status: status,
        id: entry.id,
        last5Presences: right,
        message: right.message,
      ));
    });
  }

  void _onPresenceClockIn(
      PresenceClockIn event, Emitter<PresenceState> emit) async {
    Last5Response? last5Response =
        (await presenceRepository.getLast5presences())
            .fold((l) => null, (r) => r);
    emit(PresenceState(
        status: ClockedStatus.loading, last5Presences: last5Response));

    if (!internetConnection) {
      emit(PresenceState(
          status: ClockedStatus.error,
          message: 'Periksa kembali jaringan internet anda',
          last5Presences: last5Response));
      return;
    }

    if (!isPhoneActivated) {
      emit(PresenceState(
          status: ClockedStatus.error,
          message: 'Perangkat belum diaktifkan',
          last5Presences: last5Response));
      return;
    }

    // try {
    //       final responseOfflocs = await get(Uri.parse('$API_URL/offlocs'),
    //     headers: {'Authorization': 'Bearer $token'});
    // final jsonResponse =
    //     OfficeLocationResponse.fromJson(jsonDecode(responseOfflocs.body));

    final position = await _determinePosition();

    // double distanceInMeters = Geolocator.distanceBetween(
    //     limitDecimalPlaces(double.parse(jsonResponse.data.lat)),
    //     limitDecimalPlaces(double.parse(jsonResponse.data.long)),
    //     limitDecimalPlaces(position.latitude),
    //     limitDecimalPlaces(position.longitude),
    //     );

    // if (distanceInMeters > 50) {
    //   emit(PresenceState(
    //       status: ClockedStatus.error, message: 'Lokasi tidak sesuai',
    //       last5Presences: last5Response),);
    //   return;
    // }

    // double distanceInMeters = Geolocator.distanceBetween(
    //   limitDecimalPlaces(-6.489632953337665),
    //   limitDecimalPlaces(106.73979822474786),
    //   limitDecimalPlaces(-6.490861527088263),
    //   limitDecimalPlaces(106.7401120431931),
    // );

    // double distanceInMeters = haversine(
    // -6.489632953337665,
    // 106.73979822474786,
    // -6.4890861527088263,
    // 106.7401120431931);

    // print(limitDecimalPlaces(distanceInMeters, limit: 2));

    final androidInfo = await CustomUtils.getInfo();
    final response = await presenceRepository.clockIn(
      ClockInRequest(
          type: event.type,
          phoneId: androidInfo.id,
          ciLong: position.longitude,
          ciLat: position.latitude),
    );

    last5Response = (await presenceRepository.getLast5presences())
        .fold((l) => null, (r) => r);

    response.fold((left) {
      emit(
        PresenceState(
            status: ClockedStatus.error,
            last5Presences: last5Response,
            message: left),
      );
    }, (right) {
      emit(PresenceState(
          status: ClockedStatus.clockedIn,
          id: right.data.id,
          last5Presences: last5Response,
          message: right.message));
    });
  }

  void _onPresenceClockOut(
      PresenceClockOut event, Emitter<PresenceState> emit) async {
    Last5Response? last5Response =
        (await presenceRepository.getLast5presences())
            .fold((l) => null, (r) => r);

    emit(PresenceState(
        status: ClockedStatus.loading, last5Presences: last5Response));

    if (!internetConnection) {
      emit(PresenceState(
          status: ClockedStatus.error,
          message: 'Periksa kembali jaringan internet anda'));
      return;
    }

    // final responseOfflocs = await get(Uri.parse('$API_URL/offlocs'),
    //     headers: {'Authorization': 'Bearer $token'});
    // final jsonResponse =
    //     OfficeLocationResponse.fromJson(jsonDecode(responseOfflocs.body));
    final position = await _determinePosition();

    // double distanceInMeters = Geolocator.distanceBetween(
    //   limitDecimalPlaces(double.parse(jsonResponse.data.lat)),
    //   limitDecimalPlaces(double.parse(jsonResponse.data.long)),
    //   limitDecimalPlaces(position.latitude),
    //   limitDecimalPlaces(position.longitude),
    // );

    // print(distanceInMeters);
    // if (distanceInMeters > 50) {
    //   emit(PresenceState(
    //       status: ClockedStatus.error, message: 'Lokasi tidak sesuai'));
    //   return;
    // }

    final response = await presenceRepository.clockOut(ClockOutRequest(
        id: event.id, coLong: position.longitude, coLat: position.latitude));
    last5Response = (await presenceRepository.getLast5presences())
        .fold((l) => null, (r) => r);

    response.fold((left) {
      emit(PresenceState(
          status: ClockedStatus.error,
          last5Presences: last5Response,
          message: 'Terjadi kesalahan'));
      return;
    }, (right) {
      emit(PresenceState(
          status: ClockedStatus.clockedOut,
          id: right.data.id,
          last5Presences: last5Response,
          message: right.message));
    });
  }

  @override
  PresenceState? fromJson(Map<String, dynamic> json) {
    return PresenceState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(PresenceState state) {
    return state.toJson();
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

bool _activatePhone(bool isEnabled) => isEnabled;
