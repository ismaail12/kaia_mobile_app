// ignore_for_file: unused_import

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:kaia_mobile_app/data/model/event.dart';
import 'package:kaia_mobile_app/data/request/clockin_request.dart';
import 'package:kaia_mobile_app/data/request/clockout_request.dart';
import 'package:kaia_mobile_app/data/response/clockin_response.dart';
import 'package:kaia_mobile_app/data/response/clockout_response.dart';
import 'package:kaia_mobile_app/data/response/datapresences_response.dart';
import 'package:kaia_mobile_app/data/response/last5_response.dart';
import 'package:kaia_mobile_app/data/response/offlocs_response.dart';
import 'package:kaia_mobile_app/utils/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PresenceRepository {
  Future<Either<Response, ClockInResponse>> clockIn(
      ClockInRequest request) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');

    final response = await post(Uri.parse('$API_URL/presences'), headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'type': request.type,
      'ci_long': request.ciLong.toString(),
      'ci_lat': request.ciLat.toString(),
    });

    if (response.statusCode == 200) {
      return Right(ClockInResponse.fromJson(jsonDecode(response.body)));
    } else {
      return Left(response);
    }
  }

  Future<Either<Response, ClockOutResponse>> clockOut(
      ClockOutRequest request) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');

    final response =
        await patch(Uri.parse('$API_URL/presences/${request.id}'), headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'co_long': request.coLong.toString(),
      'co_lat': request.coLat.toString(),
    });

    if (response.statusCode == 200) {
      return Right(ClockOutResponse.fromJson(jsonDecode(response.body)));
    } else {
      return Left(response);
    }
  }

  Future<Either<String, Last5Response>> getLast5presences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');

    try {
      final response = await get(
        Uri.parse('$API_URL/presences/get5'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return Right(Last5Response.fromJson(jsonDecode(response.body)));
      } else {
        return const Left('Terjadi kesalahan');
      }
    } catch (e) {
      return const Left(
          'Gagal mendapatkan data presensi, Periksa jaringan internet anda');
    }
  }

  Future<Either<String, Map<DateTime, List<Event>>>>
      fetchAndTransformEvents() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');

    try {
      final response = await get(
        Uri.parse('$API_URL/presences'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> data = jsonData['data'];

        Map<DateTime, List<Event>> dateTimeMap = {};

        for (var item in data) {
          String createdAt = item['created_at'].split('T')[0];
          DateTime date = DateTime.parse(createdAt);
          List<Event> events = dateTimeMap[date] ?? [];
          events.add(Event.fromJson(item));
          dateTimeMap[date] = events;
        }

        print(dateTimeMap);
        return Right(dateTimeMap);
      } else {
        return const Left('Terjadi kesalahan');
      }
    } catch (e) {
      return const Left(
          'Gagal mendapatkan data presensi, Periksa jaringan internet anda');
    }
  }
}
