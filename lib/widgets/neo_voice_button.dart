// import 'package:flutter/material.dart';
// import 'neo_theme.dart';
//
// /// The mic / "talk to AI" button. Handles three visual states:
// /// idle -> listening (pulsing rings) -> speaking (AI responding).
// ///
// /// Wire this up to your STT package (e.g. speech_to_text):
// /// ```dart
// /// NeoVoiceButton(
// ///   state: _voiceState, // NeoVoiceState.idle / listening / speaking
// ///   onTap: _toggleListening,
// /// )
// /// ```
// enum NeoVoiceState { idle, listening, speaking }
//
// class NeoVoiceButton extends StatefulWidget {
//   const NeoVoiceButton({
//     super.key,
//     required this.state,
//     required this.onTap,
//     this.size = 46,
//   });
//
//   final NeoVoiceState state;
//   final VoidCallback onTap;
//   final double size;
//
//   @override
//   State<NeoVoiceButton> createState() => _NeoVoiceButtonState();
// }
//
// class _NeoVoiceButtonState extends State<NeoVoiceButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     )..repeat();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Color get _accent {
//     switch (widget.state) {
//       case NeoVoiceState.listening:
//         return NeoTheme.accentRed;
//       case NeoVoiceState.speaking:
//         return NeoTheme.accentPurple;
//       case NeoVoiceState.idle:
//         return NeoTheme.accentCoral;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final active = widget.state != NeoVoiceState.idle;
//
//     return GestureDetector(
//       onLongPressStart: widget.onTap,
//       onTap: ,
//       child: SizedBox(
//         width: widget.size * 2.2,
//         height: widget.size * 2.2,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Pulsing rings — only animate while listening/speaking.
//             if (active)
//               AnimatedBuilder(
//                 animation: _controller,
//                 builder: (context, _) {
//                   return Stack(
//                     alignment: Alignment.center,
//                     children: List.generate(2, (i) {
//                       final delay = i * 0.5;
//                       var t = (_controller.value + delay) % 1.0;
//                       return Opacity(
//                         opacity: (1 - t) * 0.35,
//                         child: Container(
//                           width: widget.size + (t * widget.size * 1.4),
//                           height: widget.size + (t * widget.size * 1.4),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: _accent,
//                           ),
//                         ),
//                       );
//                     }),
//                   );
//                 },
//               ),
//             // Core neomorphic button.
//             Container(
//               width: widget.size,
//               height: widget.size,
//               decoration: BoxDecoration(
//                 color: NeoTheme.background,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: NeoTheme.shadowDark,
//                     offset: const Offset(5, 5),
//                     blurRadius: 10,
//                   ),
//                   BoxShadow(
//                     color: NeoTheme.shadowLight,
//                     offset: const Offset(-5, -5),
//                     blurRadius: 10,
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 widget.state == NeoVoiceState.speaking
//                     ? Icons.graphic_eq
//                     : Icons.mic,
//                 size: widget.size * 0.42,
//                 color: _accent,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'neo_theme.dart';
//
// /// The mic / "talk to AI" button. Handles three visual states:
// /// idle -> listening (pulsing rings) -> speaking (AI responding).
// ///
// /// Wire this up to your STT package (e.g. speech_to_text):
// /// ```dart
// /// NeoVoiceButton(
// ///   state: _voiceState, // NeoVoiceState.idle / listening / speaking
// ///   onTap: _toggleListening,
// /// )
// /// ```
// enum NeoVoiceState { idle, listening, speaking }
//
// class NeoVoiceButton extends StatefulWidget {
//   const NeoVoiceButton({
//     super.key,
//     required this.state,
//     required this.onTap,
//     this.size = 46,
//   });
//
//   final NeoVoiceState state;
//   final VoidCallback onTap;
//   final double size;
//
//   @override
//   State<NeoVoiceButton> createState() => _NeoVoiceButtonState();
// }
//
// class _NeoVoiceButtonState extends State<NeoVoiceButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     )..repeat();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Color get _accent {
//     switch (widget.state) {
//       case NeoVoiceState.listening:
//         return NeoTheme.accentRed;
//       case NeoVoiceState.speaking:
//         return NeoTheme.accentPurple;
//       case NeoVoiceState.idle:
//         return NeoTheme.accentCoral;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final active = widget.state != NeoVoiceState.idle;
//
//     return GestureDetector(
//       onLongPressStart: widget.onTap,
//       onTap: ,
//       child: SizedBox(
//         width: widget.size * 2.2,
//         height: widget.size * 2.2,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Pulsing rings — only animate while listening/speaking.
//             if (active)
//               AnimatedBuilder(
//                 animation: _controller,
//                 builder: (context, _) {
//                   return Stack(
//                     alignment: Alignment.center,
//                     children: List.generate(2, (i) {
//                       final delay = i * 0.5;
//                       var t = (_controller.value + delay) % 1.0;
//                       return Opacity(
//                         opacity: (1 - t) * 0.35,
//                         child: Container(
//                           width: widget.size + (t * widget.size * 1.4),
//                           height: widget.size + (t * widget.size * 1.4),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: _accent,
//                           ),
//                         ),
//                       );
//                     }),
//                   );
//                 },
//               ),
//             // Core neomorphic button.
//             Container(
//               width: widget.size,
//               height: widget.size,
//               decoration: BoxDecoration(
//                 color: NeoTheme.background,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: NeoTheme.shadowDark,
//                     offset: const Offset(5, 5),
//                     blurRadius: 10,
//                   ),
//                   BoxShadow(
//                     color: NeoTheme.shadowLight,
//                     offset: const Offset(-5, -5),
//                     blurRadius: 10,
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 widget.state == NeoVoiceState.speaking
//                     ? Icons.graphic_eq
//                     : Icons.mic,
//                 size: widget.size * 0.42,
//                 color: _accent,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'neo_box.dart';
import '../themes/neo_theme.dart';

/// Voice button with dual-use behavior:
///
/// Quick tap (press + release quickly):
///   -> onQuickTap() — use this to show the "Ask AI" card.
///
/// Press and hold past the long-press threshold:
///   -> onHoldStart() — use this to start speech-to-text.
///
/// Release finger after a hold:
///   -> onHoldEnd() — use this to stop speech-to-text.
///
/// Example:
/// ```dart
/// NeoVoiceButton(
///   state: _voiceState,
///   onQuickTap: () => showAskAiSheet(context),
///   onHoldStart: () async {
///     setState(() => _voiceState = NeoVoiceState.listening);
///     await speechToText.listen();
///   },
///   onHoldEnd: () async {
///     await speechToText.stop();
///     setState(() => _voiceState = NeoVoiceState.idle);
///   },
/// )
/// ```
enum NeoVoiceState { idle, listening, speaking }

class NeoVoiceButton extends StatefulWidget {
  const NeoVoiceButton({
    super.key,
    required this.state,
    required this.onHoldStart,
    required this.onHoldEnd,
    required this.onQuickTap,
    this.size = 46,
  });

  final NeoVoiceState state;

  /// Fired when the finger is held down past the long-press threshold —
  /// wire this to start speech-to-text listening.
  final VoidCallback onHoldStart;

  /// Fired when the finger lifts (or the hold gesture is cancelled) after
  /// a successful long press — wire this to stop speech-to-text listening.
  final VoidCallback onHoldEnd;

  /// Fired on a quick tap (press + release faster than the long-press
  /// threshold) — wire this to show the "Ask AI" card instead of voice.
  final VoidCallback onQuickTap;

  final double size;

  @override
  State<NeoVoiceButton> createState() => _NeoVoiceButtonState();
}

class _NeoVoiceButtonState extends State<NeoVoiceButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  /// True for as long as the finger is down, independent of [widget.state]
  /// (which tracks idle/listening/speaking). Drives the button's own
  /// raised -> pressed swap, same pattern as NeoButton/NeoIconButton.
  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _accent {
    switch (widget.state) {
      case NeoVoiceState.listening:
        return NeoTheme.accentRed;

      case NeoVoiceState.speaking:
        return NeoTheme.accentPurple;

      case NeoVoiceState.idle:
        return NeoTheme.accentCoral;
    }
  }

  final List<Color> rainbow = const [
    // Violet to Indigo
    Color(0xFF8B00FF), Color(0xFF7511FF), Color(0xFF5F22FF), Color(0xFF4A33FF), Color(0xFF3444FF), Color(0xFF1E55FF),
    // Indigo to Blue
    Color(0xFF002FA7), Color(0xFF0049C9), Color(0xFF0063EB), Color(0xFF007DFF), Color(0xFF0096FF), Color(0xFF00B0FF),
    // Blue to Green
    Color(0xFF00C8FF), Color(0xFF00D2D2), Color(0xFF00DCA6), Color(0xFF00E67A), Color(0xFF00F04E), Color(0xFF00FF00),
    // Green to Yellow
    Color(0xFF46FF00), Color(0xFF8CFF00), Color(0xFFD2FF00), Color(0xFFFFFF00), Color(0xFFFFEB00), Color(0xFFFFD700),
    // Yellow to Orange
    Color(0xFFFFC300), Color(0xFFFFB000), Color(0xFFFF9C00), Color(0xFFFF8800), Color(0xFFFF7400), Color(0xFFFF6000),
    // Orange to Red
    Color(0xFFFF4C00), Color(0xFFFF3800), Color(0xFFFF2400), Color(0xFFFF1000), Color(0xFFFF0000), Color(0xFFEB0024),
    // Red back to Violet (Closes loop cleanly for infinite animations)
    Color(0xFFD70049), Color(0xFFC3006E), Color(0xFFB00092), Color(0xFF9C00B7), Color(0xFF9300DB), Color(0xFF8F00ED),
  ];

  @override
  Widget build(BuildContext context) {
    final active = widget.state != NeoVoiceState.idle;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // Quick press + release, faster than the long-press threshold
      // (~500ms) — GestureDetector disambiguates this from a long press
      // automatically, so onTap only fires when onLongPressStart doesn't.
      onTap: widget.onQuickTap,
      // Finger held past the long-press threshold — start listening.
      onLongPressStart: (_) {
        setState(() => _pressed = true);
        widget.onHoldStart();
      },
      // Finger released after a successful long press — stop listening.
      onLongPressEnd: (_) {
        setState(() => _pressed = false);
        widget.onHoldEnd();
      },
      // Long-press gesture cancelled (e.g. finger dragged away mid-hold).
      onLongPressCancel: () {
        setState(() => _pressed = false);
        widget.onHoldEnd();
      },
      child: SizedBox(
        width: widget.size * 1.5,
        height: widget.size * 1.5,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing rings
            if (active)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Stack(
                    alignment: Alignment.center,
                    children: List.generate(2, (i) {
                      final delay = i * 0.5;
                      final t = (_controller.value + delay) % 1.0;
                      // 1. Find exactly where 't' sits inside our color list structure
                      double position = t * (rainbow.length - 1);
                      int indexA = position.toInt();
                      int indexB = (indexA + 1).clamp(0, rainbow.length - 1);

                      // 2. Extract the fractional remainder (0.0 to 1.0) between color A and color B
                      double localT = position - indexA;

                      // 3. Linearly interpolate between the two hex slots smoothly
                      Color mixedColor = Color.lerp(rainbow[indexA], rainbow[indexB], localT) ?? rainbow[indexA];
                      return Opacity(
                        opacity: (1 - t) * 0.35,
                        child: Container(
                          width: widget.size + (t * widget.size * 1.4),
                          height: widget.size + (t * widget.size * 1.4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: mixedColor,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),

            // Main button — raised at rest, pressed (carved-in) while held.
            NeoBox(
              style: _pressed ? NeoStyle.pressed : NeoStyle.raised,
              borderRadius: widget.size / 2,
              width: widget.size,
              height: widget.size,
              child: Center(
                child: Icon(
                  _pressed ? Icons.graphic_eq_outlined : Icons.travel_explore_outlined,
                  size: widget.size * 0.5,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}