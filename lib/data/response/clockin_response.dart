// To parse this JSON data, do
//
//     final clockInResponse = clockInResponseFromJson(jsonString);

import 'dart:convert';

class ClockInResponse {
    String message;
    Data data;

    ClockInResponse({
        required this.message,
        required this.data,
    });

    ClockInResponse copyWith({
        String? message,
        Data? data,
    }) => 
        ClockInResponse(
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ClockInResponse.fromRawJson(String str) => ClockInResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ClockInResponse.fromJson(Map<String, dynamic> json) => ClockInResponse(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int userId;
    String type;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    Data({
        required this.userId,
        required this.type,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    Data copyWith({
        int? userId,
        String? type,
        DateTime? updatedAt,
        DateTime? createdAt,
        int? id,
    }) => 
        Data(
            userId: userId ?? this.userId,
            type: type ?? this.type,
            updatedAt: updatedAt ?? this.updatedAt,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        type: json["type"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "type": type,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
