import 'package:flutter/material.dart';
import 'neo_box.dart';
import '../themes/neo_theme.dart';

/// An inset ("carved in") text field — used for search bars and the
/// AI assistant's chat input. Reads visually as pressed-in, matching
/// the reference design's search/input treatment.
///
/// Usage:
/// ```dart
/// NeoTextField(
///   hint: 'Ask Xplore AI anything...',
///   controller: myController,
///   leading: Icons.search,
///   trailing: Icons.mic,
///   onTrailingTap: _startVoiceInput,
/// )
/// ```
class NeoTextField extends StatelessWidget {
  const NeoTextField({
    super.key,
    this.controller,
    this.hint = 'Search...',
    this.leading,
    this.trailing,
    this.onTrailingTap,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final String hint;
  final IconData? leading;
  final IconData? trailing;
  final VoidCallback? onTrailingTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      depth: 0.2,
      style: NeoStyle.pressed,
      borderRadius: NeoTheme.radiusSm,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          if (leading != null) ...[
            Icon(leading, size: 18, color: NeoTheme.textSecondary),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: const TextStyle(fontSize: 14, color: NeoTheme.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 13, color: NeoTheme.textSecondary),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
