import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:kaia_mobile_app/utils/custom_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constant.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc() : super(DeviceLoading()) {
    on<UpdatePhone>((event, emit) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');

      final response = await put(Uri.parse('$API_URL/update-phone'),
          headers: {'Authorization': 'Bearer $token'},
          body: {"phone_id": event.deviceId});

      if (response.statusCode == 200) {
        emit(DeviceActive(event.deviceId));
      } else {
        emit(DeviceNotActive());
      }
    });

    on<GetPhone>((event, emit) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');

      final response = await get(
        Uri.parse('$API_URL/get-phone'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final androidInfo = await CustomUtils.getInfo();

      if (jsonDecode(response.body)['status']) {
        if (androidInfo.id == jsonDecode(response.body)['phone_id']) {
          emit(DeviceActive(jsonDecode(response.body)['phone_id']));
        } else {
          emit(DeviceHasRegistered());
        }
      } else {
        emit(DeviceNotActive());
      }
    });
  }
}
