import 'package:flutter/material.dart';

/// Primary call-to-action button.
///
/// Wraps [ElevatedButton] with a standard full-width layout and an optional
/// loading state that shows a [CircularProgressIndicator] and disables taps.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: effectiveOnPressed,
        icon: isLoading ? _spinner : icon!,
        label: Text(label),
      );
    }

    return ElevatedButton(
      onPressed: effectiveOnPressed,
      child: isLoading ? _spinner : Text(label),
    );
  }

  static const _spinner = SizedBox.square(
    dimension: 20,
    child: CircularProgressIndicator(
      strokeWidth: 2.5,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    ),
  );
}

/// Secondary outlined variant of [AppButton].
class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: effectiveOnPressed,
        icon: icon!,
        label: Text(label),
      );
    }

    return OutlinedButton(
      onPressed: effectiveOnPressed,
      child: isLoading
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          : Text(label),
    );
  }
}
