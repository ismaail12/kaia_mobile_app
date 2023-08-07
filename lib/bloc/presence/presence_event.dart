part of 'presence_bloc.dart';

abstract class PresenceEvent extends Equatable {
  const PresenceEvent();

  @override
  List<Object> get props => [];
}

class PresenceClockIn extends PresenceEvent {
  final String type;
  const PresenceClockIn({required this.type});

  @override
  List<Object> get props => [type];
}

class PresenceInitial extends PresenceEvent {}

class PresenceClockOut extends PresenceEvent {
  final int id;
  const PresenceClockOut({required this.id});

  @override
  List<Object> get props => [id];
}
