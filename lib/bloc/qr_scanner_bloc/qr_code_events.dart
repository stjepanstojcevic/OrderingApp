import 'package:equatable/equatable.dart';

abstract class QRCodeEvent extends Equatable {}

class QRCodeScanned extends QRCodeEvent {
  final String qrCode;
  QRCodeScanned(this.qrCode);

  @override
  List<Object?> get props => [qrCode];
}
