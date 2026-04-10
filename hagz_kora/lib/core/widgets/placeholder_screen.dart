import 'package:flutter/material.dart';

/// Temporary scaffold used during Phase 0 until real screens are implemented.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(label, style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
