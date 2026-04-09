import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hagz_kora/app.dart';
import 'package:hagz_kora/core/config/app_config.dart';

void main() {
  setUpAll(() => AppConfig.setup(AppConfig.development));

  testWidgets('app smoke test — renders without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: HagzKoraApp()));
    // Router redirects unauthenticated users to auth — just verify no crash.
    expect(find.byType(MaterialApp), findsNothing); // MaterialApp.router used
    expect(find.byType(Router<Object>), findsOneWidget);
  });
}
