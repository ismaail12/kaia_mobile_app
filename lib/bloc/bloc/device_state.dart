part of 'device_bloc.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object> get props => [];
}

class DeviceLoading extends DeviceState {}

class DeviceActive extends DeviceState {
  final String deviceId;
  const DeviceActive(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class DeviceNotActive extends DeviceState {}

class DeviceHasRegistered extends DeviceState {}
