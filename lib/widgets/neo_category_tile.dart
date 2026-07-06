import 'package:flutter/material.dart';
import 'neo_box.dart';
import '../themes/neo_theme.dart';

/// A discovery category card — e.g. "Restaurants · 42 nearby".
/// Built for a 2-column grid on the Xplore home screen.
///
/// Usage:
/// ```dart
/// GridView.count(
///   crossAxisCount: 2,
///   children: [
///     NeoCategoryTile(
///       icon: Icons.restaurant,
///       iconColor: NeoTheme.accentCoral,
///       label: 'Restaurants',
///       subtitle: '42 nearby',
///       onTap: () {},
///     ),
///   ],
/// )
/// ```
class NeoCategoryTile extends StatelessWidget {
  const NeoCategoryTile({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.iconColor = NeoTheme.accentPurple,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NeoBox(
        style: NeoStyle.raised,
        borderRadius: 32,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            NeoBox(
              style: NeoStyle.pressed,
              borderRadius: 18,
              width: 46,
              height: 46,
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: NeoTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: NeoTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
