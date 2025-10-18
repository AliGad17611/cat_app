import 'package:cat_app/cat_app.dart';
import 'package:cat_app/core/routes/app_routes.dart';
import 'package:cat_app/core/di/injection_container.dart' as di;
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const CatApp(appRoutes: AppRoutes()));
}
