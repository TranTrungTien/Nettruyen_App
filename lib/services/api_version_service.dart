import 'package:firebase_remote_config/firebase_remote_config.dart';

class ApiVersionService {
  static final ApiVersionService _instance = ApiVersionService._internal();
  factory ApiVersionService() => _instance;

  ApiVersionService._internal();

  final _remoteConfig = FirebaseRemoteConfig.instance;
  String _apiVersion = 'v2'; // Default version

  String get apiVersion => _apiVersion;

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.setDefaults(const {
      'api_version': 'v3',
    });
    await _remoteConfig.fetchAndActivate();
    _apiVersion = _remoteConfig.getString('api_version');
  }
}
