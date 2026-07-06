// import 'package:flutter/material.dart';
// import '../themes/neo_theme.dart';
//
// /// The foundational neomorphic surface. Every other widget in this kit
// /// (NeoCard, NeoButton, NeoTextField...) wraps this internally.
// ///
// /// Usage:
// /// ```dart
// /// NeoBox(
// ///   style: NeoStyle.raised,
// ///   borderRadius: NeoTheme.radiusMd,
// ///   padding: const EdgeInsets.all(16),
// ///   child: Text('Hello'),
// /// )
// /// ```
// class NeoBox extends StatelessWidget {
//   const NeoBox({
//     super.key,
//     required this.child,
//     this.style = NeoStyle.raised,
//     this.borderRadius = NeoTheme.radiusMd,
//     this.padding,
//     this.width,
//     this.height,
//     this.color,
//     this.depth = 1.0,
//   });
//
//   final Widget child;
//   final NeoStyle style;
//   final double borderRadius;
//   final EdgeInsetsGeometry? padding;
//   final double? width;
//   final double? height;
//   final Color? color;
//
//   /// Multiplier for shadow intensity (1.0 = default). Use <1 for subtle
//   /// elements (small icons), >1 for hero elements (main CTA).
//   final double depth;
//
//   @override
//   Widget build(BuildContext context) {
//     final bg = color ?? NeoTheme.background;
//     final radius = BorderRadius.circular(borderRadius);
//     final blur = NeoTheme.blur * depth;
//     final offset = NeoTheme.offset * depth;
//
//     List<BoxShadow> shadows;
//     Gradient? gradient;
//
//     switch (style) {
//       case NeoStyle.raised:
//         shadows = [
//           BoxShadow(
//             color: NeoTheme.shadowDark,
//             offset: Offset(offset, offset),
//             blurRadius: blur,
//           ),
//           BoxShadow(
//             color: NeoTheme.shadowLight,
//             offset: Offset(-offset, -offset),
//             blurRadius: blur,
//           ),
//         ];
//         break;
//       case NeoStyle.pressed:
//         // Pressed state uses an inner shadow illusion via a subtle
//         // gradient since Flutter has no native inset box-shadow.
//         shadows = [];
//         gradient = LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             NeoTheme.shadowDark.withValues(alpha: 0.6),
//             bg,
//             NeoTheme.shadowLight.withValues(alpha: 0.6),
//           ],
//           stops: const [0.0, 0.5, 1.0],
//         );
//         break;
//       case NeoStyle.flat:
//         shadows = [];
//         break;
//     }
//
//     return Container(
//       width: width,
//       height: height,
//       padding: padding,
//       decoration: BoxDecoration(
//         color: gradient == null ? bg : null,
//         gradient: gradient,
//         borderRadius: radius,
//         boxShadow: shadows,
//       ),
//       child: child,
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../themes/neo_theme.dart';

/// The foundational neomorphic surface. Every other widget in this kit
/// (NeoCard, NeoButton, NeoTextField...) wraps this internally.
///
/// This follows the standard GeeksforGeeks neumorphism recipe directly:
/// https://www.geeksforgeeks.org/flutter/neumorphism-in-flutter/
/// https://www.geeksforgeeks.org/flutter/flutter-neumorphic-button/
///
/// The trick is NOT a gradient or an inset-shadow simulation — it's just
/// a plain [Container] on the same background color as its parent, using
/// only ordinary dark + light [BoxShadow] pairs. [NeoStyle.raised] gets a
/// bigger pair (dark bottom-right, light top-left). [NeoStyle.pressed]
/// gets a smaller pair with the corners swapped, to read as "sunken".
/// [NeoStyle.flat] has no shadow at all. Because a BoxShadow only ever
/// renders around a container's edge, none of these ever wash or cover
/// the interior, on any size box.
///
/// Usage:
/// ```dart
/// NeoBox(
///   style: NeoStyle.raised,
///   borderRadius: NeoTheme.radiusMd,
///   padding: const EdgeInsets.all(16),
///   child: Text('Hello'),
/// )
/// ```
class NeoBox extends StatelessWidget {
  const NeoBox({
    super.key,
    required this.child,
    this.style = NeoStyle.raised,
    this.borderRadius = NeoTheme.radiusMd,
    this.padding,
    this.width,
    this.height,
    this.color,
    this.depth = 1.0,
  });

  final Widget child;
  final NeoStyle style;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? color;

  /// Multiplier for shadow intensity (1.0 = default). Use <1 for subtle
  /// elements (small icons), >1 for hero elements (main CTA). Scales both
  /// the raised shadow and the smaller pressed/sunken shadow.
  final double depth;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? NeoTheme.background;
    final radius = BorderRadius.circular(borderRadius);

    // Same offset/blur/spread ratios as the GeeksforGeeks sample
    // (offset 10, blur 30, spread 1), scaled by this kit's own base
    // tokens so it still respects NeoTheme.blur / NeoTheme.offset.
    final blur = NeoTheme.blur * depth;
    final offset = NeoTheme.offset * depth;
    const spread = 1.0;

    List<BoxShadow>? boxShadow;
    switch (style) {
      case NeoStyle.raised:
        boxShadow = [
          // Shadow for the bottom-right corner (away from the light).
          BoxShadow(
            color: NeoTheme.shadowDark,
            offset: Offset(offset, offset),
            blurRadius: blur,
            spreadRadius: spread,
          ),
          // Shadow for the top-left corner (toward the light).
          BoxShadow(
            color: NeoTheme.shadowLight,
            offset: Offset(-offset, -offset),
            blurRadius: blur,
            spreadRadius: spread,
          ),
        ];
        break;
      case NeoStyle.pressed:
      // "Sunken" look, still just plain BoxShadows (no gradient, no
      // custom painting) — but smaller AND with the dark/light corners
      // swapped relative to raised. Since a BoxShadow only ever renders
      // around a container's edge (it can't wash the interior), this
      // reads as a subtle inset/pressed cue without ever reproducing
      // the old full-surface gradient artifact, on any size element.
        boxShadow = [
          BoxShadow(
            color: NeoTheme.shadowDark,
            offset: Offset(-offset * 0.45, -offset * 0.45),
            blurRadius: blur * 0.55,
          ),
          BoxShadow(
            color: NeoTheme.shadowLight,
            offset: Offset(offset * 0.45, offset * 0.45),
            blurRadius: blur * 0.55,
          ),
        ];
        break;
      case NeoStyle.flat:
      // Truly flat — no shadow, flush with the background. Used for
      // dividers/backgrounds rather than interactive-looking surfaces.
        boxShadow = null;
        break;
    }

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
