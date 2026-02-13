import 'package:minh_nguyet_truyen/services/api_version_service.dart';

final apiVersionService = ApiVersionService();

String get kBaseURL =>
    "https://nettruyenapi.vercel.app/api/${apiVersionService.apiVersion}";
