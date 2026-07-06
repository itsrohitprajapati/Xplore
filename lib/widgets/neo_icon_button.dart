import 'package:flutter/material.dart';
import 'neo_box.dart';
import '../themes/neo_theme.dart';

/// A circular icon button — used for the mic button, notifications,
/// avatar frames, etc. Matches the round icon chips in the reference design.
///
/// Usage:
/// ```dart
/// NeoIconButton(
///   icon: Icons.mic,
///   iconColor: NeoTheme.accentCoral,
///   onTap: () {},
/// )
/// ```
class NeoIconButton extends StatefulWidget {
  const NeoIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 46,
    this.iconSize = 20,
    this.iconColor = NeoTheme.textPrimary,
    this.style = NeoStyle.raised,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color iconColor;

  /// Set to NeoStyle.pressed to render an "always active/selected" icon
  /// (e.g. a toggled-on filter), independent of tap animation.
  final NeoStyle style;

  @override
  State<NeoIconButton> createState() => _NeoIconButtonState();
}

class _NeoIconButtonState extends State<NeoIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final activeStyle = widget.style == NeoStyle.pressed
        ? NeoStyle.pressed
        : (_pressed ? NeoStyle.pressed : NeoStyle.raised);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: NeoBox(
        style: activeStyle,
        borderRadius: widget.size / 2,
        width: widget.size,
        height: widget.size,
        depth: 0.8,
        child: Icon(widget.icon, size: widget.iconSize, color: widget.iconColor),
      ),
    );
  }
}
