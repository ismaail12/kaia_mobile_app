// To parse this JSON data, do
//
//     final clockOutResponse = clockOutResponseFromJson(jsonString);

import 'dart:convert';

class ClockOutResponse {
    String message;
    Data data;

    ClockOutResponse({
        required this.message,
        required this.data,
    });

    ClockOutResponse copyWith({
        String? message,
        Data? data,
    }) => 
        ClockOutResponse(
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ClockOutResponse.fromRawJson(String str) => ClockOutResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ClockOutResponse.fromJson(Map<String, dynamic> json) => ClockOutResponse(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int id;
    String userId;
    String type;
    dynamic info;
    DateTime clockout;
    DateTime createdAt;
    DateTime updatedAt;

    Data({
        required this.id,
        required this.userId,
        required this.type,
        this.info,
        required this.clockout,
        required this.createdAt,
        required this.updatedAt,
    });

    Data copyWith({
        int? id,
        String? userId,
        String? type,
        dynamic info,
        DateTime? clockout,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Data(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            type: type ?? this.type,
            info: info ?? this.info,
            clockout: clockout ?? this.clockout,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        type: json["type"],
        info: json["info"],
        clockout: DateTime.parse(json["clockout"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "info": info,
        "clockout": clockout.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
