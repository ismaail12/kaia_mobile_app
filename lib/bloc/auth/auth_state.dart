part of 'auth_bloc.dart';

enum AuthStatus { initial, onLogin, loading, authenticated, error }

enum InternetStatus { connected, disconnected }

// ignore: must_be_immutable
class AuthState extends Equatable {
  User? user;
  String? message;
  String? token;
  bool? phoneStatus;
  final AuthStatus status;

  AuthState(
      {required this.status,
      this.user,
      this.token,
      this.message,
      this.phoneStatus});

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'status': status.name,
      'message': message,
      'token': token,
      'phoneStatus': phoneStatus,
    };
  }

  factory AuthState.fromJson(Map<String, dynamic> json) {
    return AuthState(
      user: User.fromJson(json['user']),
      message: json['message'],
      token: json['token'],
      phoneStatus: json['phoneStatus'],
      status: AuthStatus.values.firstWhere(
        (element) => element.name.toString() == json['status'],
      ),
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}
