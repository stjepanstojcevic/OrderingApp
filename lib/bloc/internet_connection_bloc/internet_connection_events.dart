import 'package:equatable/equatable.dart';

abstract class InternetConnectionEvent extends Equatable {}

class InternetConnected extends InternetConnectionEvent {

  @override
  List<Object?> get props => [];
}