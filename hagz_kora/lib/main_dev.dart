import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hagz_kora/app.dart';
import 'package:hagz_kora/core/config/app_config.dart';
import 'package:hagz_kora/core/storage/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.setup(AppConfig.development);

  await HiveService.initialize();

  runApp(const ProviderScope(child: HagzKoraApp()));
}
