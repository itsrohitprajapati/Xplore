import 'package:flutter/material.dart';
import 'neo_theme.dart';

/// A neomorphic on/off switch — matches the "On" pill toggle from the
/// reference image (Air Conditioner card).
///
/// Usage:
/// ```dart
/// NeoToggle(
///   value: isOn,
///   onChanged: (v) => setState(() => isOn = v),
/// )
/// ```
class NeoToggle extends StatelessWidget {
  const NeoToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = NeoTheme.accentPurple,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 52,
        height: 30,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: NeoTheme.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: NeoTheme.shadowDark,
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
            BoxShadow(
              color: NeoTheme.shadowLight,
              offset: const Offset(-2, -2),
              blurRadius: 4,
            ),
          ],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? activeColor : NeoTheme.shadowDark,
            ),
          ),
        ),
      ),
    );
  }
}
