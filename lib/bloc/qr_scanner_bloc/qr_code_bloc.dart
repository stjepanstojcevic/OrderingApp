import 'package:flutter_bloc/flutter_bloc.dart';

import 'qr_code_events.dart';
import 'qr_code_states.dart';

class QRCodeBloc extends Bloc<QRCodeEvent, QRCodeState> {
  QRCodeBloc() : super(QRCodeInitial()) {
    on<QRCodeScanned>(_onQRCodeScanned);
  }
  void _onQRCodeScanned(QRCodeScanned event, Emitter<QRCodeState> emit) {
    emit(QRCodeLoading());
    try {
      final int scannedNumber = int.parse(event.qrCode);
      if (scannedNumber < 0) {
        emit(QRCodeInvalid());
      }
      emit(QRCodeScanSuccess(event.qrCode));
    } catch (e) {
      emit(QRCodeInvalid());
    }
  }
}

