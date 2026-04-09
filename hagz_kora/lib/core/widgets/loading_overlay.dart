import 'package:flutter/material.dart';
import 'package:hagz_kora/core/theme/app_colors.dart';

/// Full-screen semi-transparent overlay with a centered progress indicator.
///
/// Wrap the page body with this widget when an async operation is running:
/// ```dart
/// LoadingOverlay(
///   isLoading: state.isLoading,
///   child: PageContent(),
/// )
/// ```
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    this.label,
    super.key,
  });

  final bool isLoading;
  final Widget child;

  /// Optional message shown below the spinner.
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          const ModalBarrier(dismissible: false, color: Colors.transparent),
        if (isLoading)
          ColoredBox(
            color: Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: _SpinnerCard(label: label),
            ),
          ),
      ],
    );
  }
}

class _SpinnerCard extends StatelessWidget {
  const _SpinnerCard({this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          if (label != null) ...[
            const SizedBox(height: 16),
            Text(
              label!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
