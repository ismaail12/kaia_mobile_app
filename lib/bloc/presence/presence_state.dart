part of 'presence_bloc.dart';

enum ClockedStatus { initial, loading, clockedIn, clockedOut, error }

// ignore: must_be_immutable
class PresenceState extends Equatable {
  ClockedStatus status;
  String? message;
  int? id;
  Last5Response? last5Presences;
  // List<Presence> presences;
PresenceState({required this.status, this.message, this.id, this.last5Presences});

  
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'id': id,
      'status': status.name,
      'last5Presences': last5Presences?.toJson()
    };
  }

  factory PresenceState.fromJson(Map<String, dynamic> json) {
    return PresenceState(
      last5Presences: Last5Response.fromJson(json['last5Presences']),
      message: json['message'],
      id: json['id'],
      status: ClockedStatus.values.firstWhere(
        (element) => element.name.toString() == json['status'],
      ),

    );
  }

  @override
  List<Object> get props => [status];
}

