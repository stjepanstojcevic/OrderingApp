// internet_connection_bloc.dart

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'internet_connection_events.dart';
import 'internet_connection_states.dart';
import 'package:ordering_app/constants/constants.dart' as constants;

class InternetConnectionBloc
    extends Bloc<InternetConnectionEvent, InternetConnectionState> {
  final MethodChannel platform = const MethodChannel(constants.methodChannelName);

  InternetConnectionBloc()
      : super(InternetConnectionInitial()) {
    on<InternetConnected>(_internetConnected);
  }

  Future<void> _internetConnected(
      InternetConnected event, Emitter<InternetConnectionState> emit) async {
    emit(InternetConnectionLoading());
    try {
      final String result = await platform.invokeMethod(constants.checkInternetConnectionLabel);

      if (result != constants.success) {
        emit(InternetConnectionFailure(result));
      } else {
        emit(InternetConnectionSuccess(result));
      }
    } catch (e) {
      emit(InternetConnectionFailure(Platform.resolvedExecutable));
    }
  }
}
