import 'package:cat_app/core/constants/api_constants.dart';
import 'package:cat_app/core/constants/storage_constants.dart';
import 'package:cat_app/core/constants/pagination_constants.dart';
import 'package:cat_app/core/constants/ui_constants.dart';

class AppConstants {
  // API
  static const String baseUrl = ApiConstants.baseUrl;
  static const int connectionTimeout = ApiConstants.connectionTimeout;
  static const int receiveTimeout = ApiConstants.receiveTimeout;
  static const int sendTimeout = ApiConstants.sendTimeout;
  // API Endpoints
  static const String animalsListEndpoint = ApiConstants.animalsListEndpoint;
  static const String categoriesEndpoint = ApiConstants.categoriesEndpoint;

  // Storage
  static const bool isOnboardingCompleted = StorageConstants.isOnboardingCompleted;

  // UI
  static const double defaultPadding = UIConstants.defaultPadding;
  static const double defaultBorderRadius = UIConstants.defaultBorderRadius;

  // Pagination
  static const int pageSize = PaginationConstants.pageSize;
}
