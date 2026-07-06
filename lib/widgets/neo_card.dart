import 'package:flutter/material.dart';
import 'neo_box.dart';
import '../themes/neo_theme.dart';

/// A raised card for grouping content — the neomorphic equivalent
/// of Material's Card widget.
///
/// Usage:
/// ```dart
/// NeoCard(
///   child: Column(children: [...]),
/// )
/// ```
class NeoCard extends StatelessWidget {
  const NeoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = NeoTheme.radiusLg,
    this.margin,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  /// If provided, the whole card becomes tappable (wraps in InkWell-free
  /// GestureDetector so the neomorphic shadow isn't disturbed by ripples).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = NeoBox(
      style: NeoStyle.raised,
      borderRadius: borderRadius,
      padding: padding,
      child: child,
    );

    final wrapped = margin == null ? card : Padding(padding: margin!, child: card);

    if (onTap == null) return wrapped;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: wrapped,
    );
  }
}
