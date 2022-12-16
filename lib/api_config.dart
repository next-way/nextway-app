/// Read config from api_env.yaml
/// Override settings from api_env.dev.yaml
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

/// Get API config
Future<Map> getApiConfig() async {
  final List<String> apiEnvList = [
    'api_env/api_env.yaml',
    'api_env/api_env.dev.yaml',
  ];

  Map<dynamic, dynamic> apiConfig = {};
  for (String sourceAsset in apiEnvList) {
    try {
      final yamlString = await rootBundle.loadString(sourceAsset);
      // final configFile = File(sourceAsset);
      // final yamlString = await configFile.readAsString();
      apiConfig.addAll(loadYaml(yamlString));
    } on FlutterError catch (_) {
      /// The api_env*.yaml file does not exist or cannot access
    }
  }
  return apiConfig;
}

/// Favor FlavorSettings over getApiConfig
const String localApiHost = "192.168.55.181:8082";
const String stagingHost = "api-stage42.next-way.org";

class FlavorSettings {
  final String apiBaseUrl;
  final String apiTokenUrl;
  final String flavorId;

  FlavorSettings.development()
      : apiBaseUrl = localApiHost,
        apiTokenUrl = localApiHost + "/token",
        flavorId = "development"; // TODO Configure better?
  FlavorSettings.production()
      : apiBaseUrl = stagingHost,
        apiTokenUrl = stagingHost + "/token",
        flavorId = "production"; // Same as staging for now
  FlavorSettings.staging()
      : apiBaseUrl = stagingHost,
        apiTokenUrl = stagingHost + "/token",
        flavorId = "staging";
}

Future<FlavorSettings> getFlavorSettings() async {
  String flavor =
      await const MethodChannel('flavor').invokeMethod<String>('getFlavor') ??
          "development";

  print('STARTED WITH FLAVOR $flavor');

  if (flavor == 'development') {
    return FlavorSettings.development();
  } else if (flavor == 'production') {
    return FlavorSettings.production();
  } else if (flavor == 'staging') {
    return FlavorSettings.staging();
  } else {
    throw Exception("Unknown flavor: $flavor");
  }
}
