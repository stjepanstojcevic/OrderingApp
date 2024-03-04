import 'package:equatable/equatable.dart';

abstract class QRCodeState extends Equatable {}

class QRCodeInitial extends QRCodeState {
  @override
  List<Object?> get props => [];
}

class QRCodeScanSuccess extends QRCodeState {
  final String qrCode;
  QRCodeScanSuccess(this.qrCode);

  @override
  List<Object?> get props => [qrCode];
}

class QRCodeInvalid extends QRCodeState {
  @override
  List<Object?> get props => [];
}

class QRCodeLoading extends QRCodeState {
  @override
  List<Object?> get props => [];
}
