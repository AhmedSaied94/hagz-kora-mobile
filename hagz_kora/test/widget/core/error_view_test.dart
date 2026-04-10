import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hagz_kora/core/widgets/app_button.dart';
import 'package:hagz_kora/core/widgets/error_view.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: child));

void main() {
  group('ErrorView', () {
    testWidgets('shows error message', (tester) async {
      await tester.pumpWidget(
        _wrap(const ErrorView(message: 'Something went wrong')),
      );
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('shows default error icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const ErrorView(message: 'Oops')),
      );
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry provided', (tester) async {
      await tester.pumpWidget(
        _wrap(ErrorView(message: 'Error', onRetry: () {})),
      );
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('hides retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(
        _wrap(const ErrorView(message: 'Error')),
      );
      expect(find.byType(AppButton), findsNothing);
    });

    testWidgets('calls onRetry when retry button tapped', (tester) async {
      var retried = 0;
      await tester.pumpWidget(
        _wrap(ErrorView(message: 'Error', onRetry: () => retried++)),
      );
      await tester.tap(find.text('Try Again'));
      expect(retried, 1);
    });

    testWidgets('uses custom icon when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ErrorView(
            message: 'No wifi',
            icon: Icons.wifi_off_outlined,
          ),
        ),
      );
      expect(find.byIcon(Icons.wifi_off_outlined), findsOneWidget);
    });
  });

  group('ErrorBanner', () {
    testWidgets('shows error message', (tester) async {
      await tester.pumpWidget(
        _wrap(const ErrorBanner(message: 'Invalid email')),
      );
      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('shows error icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const ErrorBanner(message: 'Err')),
      );
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
