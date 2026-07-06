import 'package:flutter/material.dart';

/// Central place for all neomorphic design tokens.
/// Tweak these and every widget in the kit updates automatically.
class NeoTheme {
  NeoTheme._();

  // Base surface color — everything (bg, cards, buttons) shares this.
  // Neomorphism relies on ONE base color with light/dark shadow pairs.
  static const Color background = Color(0xFFE8E8EC);

  // Shadow pair: light shadow (top-left) + dark shadow (bottom-right).
  static const Color shadowDark = Color(0xFFA6A4A4);
  static const Color shadowLight = Color(0xFFFFFFFF);

  // Text colors
  static const Color textPrimary = Color(0xFF2C2C2E);
  static const Color textSecondary = Color(0xFF8A8A92);

  // Accent colors (use sparingly — icons, active states, highlights)
  static const Color accentPurple = Color(0xFF6B6BF0);
  static const Color accentCoral = Color(0xFFD85A30);
  static const Color accentTeal = Color(0xFF0F6E56);
  static const Color accentGreen = Color(0xFF1D9E75);
  static const Color accentAmber = Color(0xFFBA7517);
  static const Color accentRed = Color(0xFFE24B4A);

  // Default corner radii
  static const double radiusSm = 12;
  static const double radiusMd = 18;
  static const double radiusLg = 24;

  // Default blur/offset for raised shadows
  static const double blur = 12;
  static const double offset = 6;
}

/// Visual state a neomorphic surface can be in.
enum NeoStyle {
  /// Pops out of the background (default for cards/buttons at rest).
  raised,

  /// Pressed into the background (active/selected/pressed state).
  pressed,

  /// Flat, no shadow — used for plain backgrounds or dividers.
  flat,
}
