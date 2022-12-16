import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:nextway/api_config.dart';
import 'package:nextway/app.dart';
import 'package:provider/provider.dart';

import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState

  FlavorConfig(name: "STAGING", variables: {
    "apiBaseUrl": stagingHost,
    "apiTokenUrl": stagingHost + "/token",
    "flavorId": "staging",
  });

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}
