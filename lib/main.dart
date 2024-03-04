import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/ui/qr_scanner_screen.dart';
import 'package:ordering_app/ui/theme/theme.dart';

import 'bloc/qr_scanner_bloc/qr_code_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: BlocProvider(
          create: (_) => QRCodeBloc(), child: const QRCodeScannerView()),
    );
  }
}
