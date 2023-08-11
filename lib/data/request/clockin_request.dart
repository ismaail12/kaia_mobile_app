// To parse this JSON data, do
//
//     final ClockInRequest = ClockInRequestFromJson(jsonString);

import 'dart:convert';

class ClockInRequest {
    String type;
    String phoneId;
    double ciLong;
    double ciLat;
    String? info;

    ClockInRequest({
        required this.type,
        required this.phoneId,
        required this.ciLong,
        required this.ciLat,
        this.info,
    });

    ClockInRequest copyWith({
        String? type,
        String? phoneId,
        double? ciLong,
        double? ciLat,
        dynamic info,
    }) => 
        ClockInRequest(
            type: type ?? this.type,
            phoneId: phoneId ?? this.phoneId,
            ciLong: ciLong ?? this.ciLong,
            ciLat: ciLat ?? this.ciLat,
            info: info ?? this.info,
        );

    factory ClockInRequest.fromRawJson(String str) => ClockInRequest.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ClockInRequest.fromJson(Map<String, dynamic> json) => ClockInRequest(
        type: json["type"],
        phoneId: json["phone_id"],
        ciLong: json["ci_long"]?.toDouble(),
        ciLat: json["ci_lat"]?.toDouble(),
        info: json["info"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "phone_id": phoneId,
        "ci_long": ciLong,
        "ci_lat": ciLat,
        "info": info,
    };
}
