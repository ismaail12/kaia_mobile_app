// To parse this JSON data, do
//
//     final presence = presenceFromJson(jsonString);

import 'dart:convert';

Presence presenceFromJson(String str) => Presence.fromJson(json.decode(str));

String presenceToJson(Presence data) => json.encode(data.toJson());

class Presence {
    Data data;
    bool isClockedIn;

    Presence({
        required this.data,
        required this.isClockedIn,
    });

    Presence copyWith({
        Data? data,
        bool? isClockedIn,
    }) => 
        Presence(
            data: data ?? this.data,
            isClockedIn: isClockedIn ?? this.isClockedIn,
        );

    factory Presence.fromJson(Map<String, dynamic> json) => Presence(
        data: Data.fromJson(json["data"]),
        isClockedIn: json["isClockedIn"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "isClockedIn": isClockedIn,
    };
}

class Data {
    int id;
    String userId;
    DateTime jamMasuk;
    DateTime jamPulang;
    String jenis;
    String status;
    DateTime createdAt;
    DateTime updatedAt;

    Data({
        required this.id,
        required this.userId,
        required this.jamMasuk,
        required this.jamPulang,
        required this.jenis,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
    });

    Data copyWith({
        int? id,
        String? userId,
        DateTime? jamMasuk,
        DateTime? jamPulang,
        String? jenis,
        String? status,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Data(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            jamMasuk: jamMasuk ?? this.jamMasuk,
            jamPulang: jamPulang ?? this.jamPulang,
            jenis: jenis ?? this.jenis,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        jamMasuk: DateTime.parse(json["jam_masuk"]),
        jamPulang: DateTime.parse(json["jam_pulang"]),
        jenis: json["jenis"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "jam_masuk": jamMasuk.toIso8601String(),
        "jam_pulang": jamPulang.toIso8601String(),
        "jenis": jenis,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
