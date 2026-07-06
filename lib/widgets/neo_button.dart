import 'package:flutter/material.dart';
import 'neo_box.dart';
import '../themes/neo_theme.dart';

/// A button that visually "presses into" the background when tapped —
/// the signature neomorphic interaction.
///
/// Usage:
/// ```dart
/// NeoButton(
///   onPressed: () {},
///   child: Text('Plan my trip'),
/// )
/// ```
class NeoButton extends StatefulWidget {
  const NeoButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.borderRadius = NeoTheme.radiusMd,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    this.width,
  });

  final Widget child;
  final VoidCallback onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        width: widget.width,
        child: NeoBox(
          style: _pressed ? NeoStyle.pressed : NeoStyle.raised,
          borderRadius: widget.borderRadius,
          padding: widget.padding,
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
