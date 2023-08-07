// To parse this JSON data, do
//
//     final dataPresencesResponse = dataPresencesResponseFromMap(jsonString);

import 'dart:convert';

class DataPresencesResponse {
    String message;
    List<Datum> data;

    DataPresencesResponse({
        required this.message,
        required this.data,
    });

    DataPresencesResponse copyWith({
        String? message,
        List<Datum>? data,
    }) => 
        DataPresencesResponse(
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory DataPresencesResponse.fromJson(String str) => DataPresencesResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DataPresencesResponse.fromMap(Map<String, dynamic> json) => DataPresencesResponse(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class Datum {
    int id;
    String name;
    String type;
    DateTime createdAt;
    dynamic clockout;
    dynamic info;

    Datum({
        required this.id,
        required this.name,
        required this.type,
        required this.createdAt,
        this.clockout,
        this.info,
    });

    Datum copyWith({
        int? id,
        String? name,
        String? type,
        DateTime? createdAt,
        dynamic clockout,
        dynamic info,
    }) => 
        Datum(
            id: id ?? this.id,
            name: name ?? this.name,
            type: type ?? this.type,
            createdAt: createdAt ?? this.createdAt,
            clockout: clockout ?? this.clockout,
            info: info ?? this.info,
        );

    factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
        clockout: json["clockout"],
        info: json["info"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "clockout": clockout,
        "info": info,
    };
}
