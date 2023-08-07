// To parse this JSON data, do
//
//     final last5Response = last5ResponseFromJson(jsonString);

import 'dart:convert';

class Last5Response {
    String message;
    Map<String, Datum> data;

    Last5Response({
        required this.message,
        required this.data,
    });

    Last5Response copyWith({
        String? message,
        Map<String, Datum>? data,
    }) => 
        Last5Response(
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory Last5Response.fromRawJson(String str) => Last5Response.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Last5Response.fromJson(Map<String, dynamic> json) => Last5Response(
        message: json["message"],
        data: Map.from(json["data"]).map((k, v) => MapEntry<String, Datum>(k, Datum.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class Datum {
    int id;
    String userId;
    String type;
    dynamic info;
    DateTime? clockout;
    DateTime createdAt;
    DateTime updatedAt;

    Datum({
        required this.id,
        required this.userId,
        required this.type,
        this.info,
        this.clockout,
        required this.createdAt,
        required this.updatedAt,
    });

    Datum copyWith({
        int? id,
        String? userId,
        String? type,
        dynamic info,
        DateTime? clockout,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            type: type ?? this.type,
            info: info ?? this.info,
            clockout: clockout ?? this.clockout,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        type: json["type"],
        info: json["info"],
        clockout: json["clockout"] == null ? null : DateTime.parse(json["clockout"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "info": info,
        "clockout": clockout?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
