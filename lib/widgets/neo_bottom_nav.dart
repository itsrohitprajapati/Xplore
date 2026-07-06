// import 'package:flutter/material.dart';
// import 'neo_box.dart';
// import '../themes/neo_theme.dart';
//
// /// A single tab in [NeoBottomNavBar].
// class NeoNavItem {
//   const NeoNavItem({
//     required this.icon,
//     required this.label,
//     this.activeColor = NeoTheme.accentPurple,
//   });
//
//   final IconData icon;
//   final String label;
//
//   /// Color used for the icon + label when this tab is selected.
//   final Color activeColor;
// }
//
// /// Floating neomorphic bottom navigation bar.
// ///
// /// Usage:
// /// ```dart
// /// Scaffold(
// ///   body: ...,
// ///   bottomNavigationBar: NeoBottomNavBar(
// ///     currentIndex: _tabIndex,
// ///     onTap: (i) => setState(() => _tabIndex = i),
// ///     items: const [
// ///       NeoNavItem(icon: Icons.explore_outlined, label: 'Discover'),
// ///       NeoNavItem(icon: Icons.map_outlined, label: 'Map', activeColor: NeoTheme.accentTeal),
// ///       NeoNavItem(icon: Icons.route_outlined, label: 'Trips', activeColor: NeoTheme.accentCoral),
// ///       NeoNavItem(icon: Icons.person_outline, label: 'Profile', activeColor: NeoTheme.accentGreen),
// ///     ],
// ///   ),
// /// )
// /// ```
// class NeoBottomNavBar extends StatelessWidget {
//   const NeoBottomNavBar({
//     super.key,
//     required this.items,
//     required this.currentIndex,
//     required this.onTap,
//     this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 16),
//   });
//
//   final List<NeoNavItem> items;
//   final int currentIndex;
//   final ValueChanged<int> onTap;
//   final EdgeInsetsGeometry margin;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: margin,
//       child: NeoBox(
//         style: NeoStyle.raised,
//         borderRadius: 28,
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: List.generate(items.length, (i) {
//             final item = items[i];
//             final selected = i == currentIndex;
//             return Expanded(
//               child: GestureDetector(
//                 onTap: () => onTap(i),
//                 behavior: HitTestBehavior.opaque,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 180),
//                   curve: Curves.easeOut,
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: selected
//                         ? [
//                             BoxShadow(
//                               color: NeoTheme.shadowDark,
//                               offset: const Offset(3, 3),
//                               blurRadius: 6,
//                             ),
//                             BoxShadow(
//                               color: NeoTheme.shadowLight,
//                               offset: const Offset(-3, -3),
//                               blurRadius: 6,
//                             ),
//                           ]
//                         : [],
//                     gradient: selected
//                         ? LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [
//                               NeoTheme.shadowDark.withValues(alpha: 0.35),
//                               NeoTheme.background,
//                               NeoTheme.shadowLight.withValues(alpha: 0.35),
//                             ],
//                             stops: const [0.0, 0.5, 1.0],
//                           )
//                         : null,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         item.icon,
//                         size: 20,
//                         color: selected ? item.activeColor : NeoTheme.textSecondary,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         item.label,
//                         style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
//                           color: selected ? item.activeColor : NeoTheme.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'neo_box.dart';
import 'neo_voice_button.dart';
import '../themes/neo_theme.dart';

/// A single tab in [NeoBottomNavBar].
class NeoNavItem {
  const NeoNavItem({
    required this.icon,
    required this.label,
    this.activeColor = NeoTheme.accentPurple,
  });

  final IconData icon;
  final String label;

  /// Color used for the icon + label when this tab is selected.
  final Color activeColor;
}

/// Floating neomorphic bottom navigation bar. Optionally merges a
/// [NeoVoiceButton] into the center, floating slightly above the bar —
/// the classic "notch FAB" bottom-nav pattern — so the mic control lives
/// in one shared place across every tab instead of a per-screen FAB.
///
/// Usage (mic merged in):
/// ```dart
/// NeoBottomNavBar(
///   currentIndex: _tabIndex,
///   onTap: (i) => setState(() => _tabIndex = i),
///   items: const [
///     NeoNavItem(icon: Icons.explore_outlined, label: 'Discover'),
///     NeoNavItem(icon: Icons.map_outlined, label: 'Map'),
///     NeoNavItem(icon: Icons.airplane_ticket_outlined, label: 'Trips'),
///     NeoNavItem(icon: Icons.person_outline, label: 'Profile'),
///   ],
///   micState: _voiceState,
///   onMicHoldStart: _startVoice,
///   onMicHoldEnd: _stopVoice,
/// )
/// ```
///
/// Omit the three `mic*` parameters to get a plain nav bar with no center
/// button, same as before.
class NeoBottomNavBar extends StatelessWidget {
  const NeoBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 16),
    this.micState,
    this.onMicHoldStart,
    this.onMicHoldEnd,
    this.onMicQuickTap,
    this.micSize = 75,
  });

  final List<NeoNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final EdgeInsetsGeometry margin;

  /// Current voice state for the merged mic button. Pass this along with
  /// [onMicHoldStart], [onMicHoldEnd], and [onMicQuickTap] to show the
  /// mic; leave all four null for a plain bar with no center button.
  final NeoVoiceState? micState;

  /// Fired when the mic is held past the long-press threshold — start
  /// speech-to-text listening here.
  final VoidCallback? onMicHoldStart;

  /// Fired when the finger lifts after a hold — stop speech-to-text here.
  final VoidCallback? onMicHoldEnd;

  /// Fired on a quick tap of the mic — show the "Ask AI" card here.
  final VoidCallback? onMicQuickTap;

  /// Diameter of the mic button's core circle (matches [NeoVoiceButton.size]).
  final double micSize;

  bool get _hasMic =>
      micState != null &&
      onMicHoldStart != null &&
      onMicHoldEnd != null &&
      onMicQuickTap != null;

  @override
  Widget build(BuildContext context) {
    // Reserve a gap in the middle of the row for the mic to sit above,
    // splitting the tabs evenly left/right of it (e.g. 4 items -> 2 + 2).
    final midIndex = (items.length / 2).ceil();
    final micSlotWidth = micSize + 20;

    final rowChildren = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (_hasMic && i == midIndex) {
        rowChildren.add(SizedBox(width: micSlotWidth));
      }
      final item = items[i];
      final selected = i == currentIndex;
      rowChildren.add(
        Expanded(
          child: GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: _NeoNavItemContent(item: item, selected: selected),
          ),
        ),
      );
    }

    final bar = NeoBox(
      style: NeoStyle.raised,
      borderRadius: 28,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: rowChildren,
      ),
    );

    if (!_hasMic) {
      return Padding(padding: margin, child: bar);
    }

    return Padding(
      padding: margin,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          bar,
          // Floats above the bar, horizontally centered by the Stack's
          // own alignment since this Positioned only pins `top`.
          Positioned(
            top: -micSize * 0.23,
            child: NeoVoiceButton(
              state: micState!,
              onHoldStart: onMicHoldStart!,
              onHoldEnd: onMicHoldEnd!,
              onQuickTap: onMicQuickTap!,
              size: micSize,
            ),
          ),
        ],
      ),
    );
  }
}

/// The icon + label content for a single nav tab, with the selected-state
/// highlight. Extracted so [NeoBottomNavBar] can insert a spacer between
/// items without disturbing each item's own animation/decoration.
class _NeoNavItemContent extends StatelessWidget {
  const _NeoNavItemContent({required this.item, required this.selected});

  final NeoNavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: selected
            ? [
          BoxShadow(
            color: NeoTheme.shadowDark,
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: NeoTheme.shadowLight,
            offset: const Offset(-3, -3),
            blurRadius: 6,
          ),
        ]
            : [],
        gradient: selected
            ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NeoTheme.shadowDark.withValues(alpha: 0.35),
            NeoTheme.background,
            NeoTheme.shadowLight.withValues(alpha: 0.35),
          ],
          stops: const [0.0, 0.5, 1.0],
        )
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 20,
            color: selected ? item.activeColor : NeoTheme.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? item.activeColor : NeoTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
