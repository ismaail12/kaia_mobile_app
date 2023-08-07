// To parse this JSON data, do
//
//     final officeLocationResponse = officeLocationResponseFromJson(jsonString);

import 'dart:convert';

class OfficeLocationResponse {
    String message;
    Data data;

    OfficeLocationResponse({
        required this.message,
        required this.data,
    });

    OfficeLocationResponse copyWith({
        String? message,
        Data? data,
    }) => 
        OfficeLocationResponse(
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory OfficeLocationResponse.fromRawJson(String str) => OfficeLocationResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory OfficeLocationResponse.fromJson(Map<String, dynamic> json) => OfficeLocationResponse(
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
    String name;
    String long;
    String lat;
    DateTime createdAt;
    DateTime updatedAt;

    Data({
        required this.id,
        required this.name,
        required this.long,
        required this.lat,
        required this.createdAt,
        required this.updatedAt,
    });

    Data copyWith({
        int? id,
        String? name,
        String? long,
        String? lat,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Data(
            id: id ?? this.id,
            name: name ?? this.name,
            long: long ?? this.long,
            lat: lat ?? this.lat,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        long: json["long"],
        lat: json["lat"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "long": long,
        "lat": lat,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
