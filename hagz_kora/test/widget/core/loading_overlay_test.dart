import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hagz_kora/core/widgets/loading_overlay.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: SizedBox.expand(child: child)));

void main() {
  group('LoadingOverlay', () {
    testWidgets('renders child when not loading', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LoadingOverlay(
            isLoading: false,
            child: Text('Content'),
          ),
        ),
      );
      expect(find.text('Content'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows spinner when loading', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LoadingOverlay(
            isLoading: true,
            child: Text('Content'),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('child still in tree when loading', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LoadingOverlay(
            isLoading: true,
            child: Text('Content'),
          ),
        ),
      );
      // Child is in the stack beneath the overlay.
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('shows label when loading with label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LoadingOverlay(
            isLoading: true,
            label: 'Please wait…',
            child: SizedBox.shrink(),
          ),
        ),
      );
      expect(find.text('Please wait…'), findsOneWidget);
    });

    testWidgets('does not show label when not loading', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LoadingOverlay(
            isLoading: false,
            label: 'Please wait…',
            child: SizedBox.shrink(),
          ),
        ),
      );
      expect(find.text('Please wait…'), findsNothing);
    });

    testWidgets('dismisses overlay when isLoading transitions to false',
        (tester) async {
      var loading = true;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  SizedBox.expand(
                    child: LoadingOverlay(
                      isLoading: loading,
                      child: const Text('Body'),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: ElevatedButton(
                      onPressed: () => setState(() => loading = false),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.text('Done'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
