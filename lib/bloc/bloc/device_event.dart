part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

class UpdatePhone extends DeviceEvent {
  final String deviceId;
  const UpdatePhone(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class GetPhone extends DeviceEvent {
  
  const GetPhone();

  @override
  List<Object> get props => [];
}