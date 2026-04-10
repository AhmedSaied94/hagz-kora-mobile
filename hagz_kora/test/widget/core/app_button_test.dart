import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hagz_kora/core/widgets/app_button.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('AppButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        _wrap(AppButton(label: 'Book Now', onPressed: () {})),
      );
      expect(find.text('Book Now'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        _wrap(AppButton(label: 'Tap', onPressed: () => tapped++)),
      );
      await tester.tap(find.text('Tap'));
      expect(tapped, 1);
    });

    testWidgets('shows spinner and ignores taps when isLoading=true',
        (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        _wrap(
          AppButton(
            label: 'Loading',
            onPressed: () => tapped++,
            isLoading: true,
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, 0);
    });

    testWidgets('disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        _wrap(const AppButton(label: 'Disabled', onPressed: null)),
      );
      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNull);
    });
  });

  group('AppOutlinedButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        _wrap(AppOutlinedButton(label: 'Cancel', onPressed: () {})),
      );
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        _wrap(AppOutlinedButton(label: 'Go', onPressed: () => tapped++)),
      );
      await tester.tap(find.text('Go'));
      expect(tapped, 1);
    });

    testWidgets('shows spinner when isLoading=true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AppOutlinedButton(
            label: 'Loading',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
