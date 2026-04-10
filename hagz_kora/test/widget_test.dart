import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hagz_kora/app.dart';
import 'package:hagz_kora/core/config/app_config.dart';

void main() {
  setUpAll(() => AppConfig.setup(AppConfig.development));

  testWidgets('app smoke test — renders MaterialApp without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: HagzKoraApp()));
    await tester.pump();

    // MaterialApp.router is a named constructor of MaterialApp, not a subtype,
    // so byType(MaterialApp) correctly finds exactly one widget.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
