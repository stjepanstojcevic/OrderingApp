import 'dart:async';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/bloc/drinks_list_bloc/drinks_list_bloc.dart';
import 'package:ordering_app/bloc/qr_scanner_bloc/qr_code_bloc.dart';
import 'package:ordering_app/bloc/qr_scanner_bloc/qr_code_events.dart';
import 'package:ordering_app/bloc/qr_scanner_bloc/qr_code_states.dart';
import 'package:ordering_app/constants/constants.dart' as constants;
import 'package:ordering_app/constants/konstante.dart' as konstante;
import 'package:ordering_app/ui/drinks_list_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerView extends StatefulWidget {
  const QRCodeScannerView({Key? key}) : super(key: key);

  @override
  State<QRCodeScannerView> createState() => _QRCodeScannerViewState();
}

class _QRCodeScannerViewState extends State<QRCodeScannerView> {
  QRViewController? controller;
  String? _defaultLocale;
  String? _qrNotValidLabel;
  String? _checkInternetConnectionLabel;
  String? _noInternetConnectionLabel;

  static const platform = MethodChannel(constants.methodChannelName);

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _checkInternetConnection();
    _initPlatformState();
    super.initState();
  }

  Future<void> _checkInternetConnection() async {
    try {
      final String result = await platform.invokeMethod(constants.checkInternetConnectionLabel);

      if (result == constants.failure) {
        _showSnackbar(result);
      }
    } on PlatformException catch (e) {
      print("$e");
    }
  }

  Future<void> _initPlatformState() async {
    await _getDefaultLocale();
    await _loadConstants();
  }

  Future<void> _getDefaultLocale() async {
    try {
      final defaultLocale = await Devicelocale.defaultLocale;
      setState(() => _defaultLocale = defaultLocale);
    } on PlatformException catch (e) {
      print("$e");
    }
  }

  Future<void> _loadConstants() async {
    final locale = _defaultLocale ?? 'en-US';
    setState(() {
      _qrNotValidLabel = (locale == 'hr-HR') ? konstante.qrNotValidLabel : constants.qrNotValidLabel;
      _checkInternetConnectionLabel = (locale == 'hr-HR') ? konstante.checkInternetConnectionLabel : constants.checkInternetConnectionLabel;
      _noInternetConnectionLabel = (locale == 'hr-HR') ? konstante.noInternetConnectionLabel : constants.noInternetConnectionLabel;
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_noInternetConnectionLabel ?? ''),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<QRCodeBloc, QRCodeState>(
        listener: _qrCodeStateListener,
        builder: (context, state) => _buildStateContent(context, state),
      ),
    );
  }

  void _qrCodeStateListener(BuildContext context, QRCodeState state) {
    if (state is QRCodeScanSuccess) {
      _checkInternetConnectionForResult(context, state.qrCode);
    } else if (state is QRCodeInvalid) {
      _showInvalidQRSnackBar(context);
    }
  }

  void _checkInternetConnectionForResult(BuildContext context, String qrCode) async {
    try {
      final String result = await platform.invokeMethod(_checkInternetConnectionLabel ?? '');
      if (result == constants.success) {
          _navigateToDrinksListView(context, qrCode);
          constants.qrCode = qrCode;
      } else {
        _showSnackbar(result);
      }
    } on PlatformException catch (_) {
      print("Check internet connection error");
    }
  }

  Widget _buildStateContent(BuildContext context, QRCodeState state) {
    if (state is QRCodeLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return _buildQRView(context);
  }

  Widget _buildQRView(BuildContext context) {
    return QRView(
      key: GlobalKey(debugLabel: 'QR'),
      onQRViewCreated: (QRViewController controller) {
        _onQRViewCreated(controller, context);
      },
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).colorScheme.primary,
        borderRadius: constants.qrDimension,
        borderLength: constants.qrDimension,
        borderWidth: constants.qrDimension,
        cutOutSize: MediaQuery.of(context).size.width,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        BlocProvider.of<QRCodeBloc>(context).add(QRCodeScanned(scanData.code!));
      }
    });
  }

  void _navigateToDrinksListView(BuildContext context, String qrCode) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return BlocProvider<DrinksListBloc>(
        create: (context) => DrinksListBloc(),
        child: DrinksListScreen(qrCode: qrCode),
      );
    }));
  }

  void _showInvalidQRSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_qrNotValidLabel ?? ''),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
