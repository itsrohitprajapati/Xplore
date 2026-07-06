// import 'package:flutter/material.dart';
// import '../widgets/neo_widgets.dart';
//
// /// Drop-in demo showing the widget kit assembled into the Xplore home
// /// screen from the design mockup. Copy/adapt sections as needed —
// /// this file is meant as a working reference, not a fixed final screen.
// class HomeScreenDemo extends StatefulWidget {
//   const HomeScreenDemo({super.key});
//
//   @override
//   State<HomeScreenDemo> createState() => _HomeScreenDemoState();
// }
//
// class _HomeScreenDemoState extends State<HomeScreenDemo> {
//   NeoVoiceState _voiceState = NeoVoiceState.idle;
//
//   // void _toggleVoice() {
//   //   setState(() {
//   //     _voiceState = _voiceState == NeoVoiceState.idle
//   //         ? NeoVoiceState.listening
//   //         : NeoVoiceState.idle;
//   //   });
//   //   // TODO: wire to speech_to_text package here.
//   //   // On result -> send to your AI backend -> set NeoVoiceState.speaking
//   //   // while flutter_tts plays the response -> back to idle when done.
//   // }
//
//   void _startVoice() {
//     setState(() {
//       _voiceState = NeoVoiceState.listening;
//     });
//
//     // TODO:
//     // await speechToText.listen();
//   }
//
//   void _stopVoice() {
//     setState(() {
//       _voiceState = NeoVoiceState.idle;
//     });
//
//     // TODO:
//     // await speechToText.stop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: NeoTheme.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // --- Top bar: location + notifications ---
//               Row(
//                 children: [
//                   const NeoIconButton(
//                     icon: Icons.location_on,
//                     iconColor: NeoTheme.accentPurple,
//                     onTap: _noop,
//                   ),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Exploring near',
//                             style: TextStyle(fontSize: 11, color: NeoTheme.textSecondary)),
//                         Text('Connaught Place, Delhi',
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: NeoTheme.textPrimary)),
//                       ],
//                     ),
//                   ),
//                   NeoIconButton(icon: Icons.notifications_none, onTap: _noop),
//                 ],
//               ),
//               const SizedBox(height: 18),
//
//               // --- AI assistant card with search + voice ---
//               NeoCard(
//                 borderRadius: 36,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         const NeoBox(
//                           style: NeoStyle.pressed,
//                           borderRadius: 17,
//                           width: 34,
//                           height: 34,
//                           child: Icon(Icons.auto_awesome,
//                               size: 15, color: NeoTheme.accentPurple),
//                         ),
//                         const SizedBox(width: 8),
//                         const Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Ask Xplore AI',
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                       color: NeoTheme.textPrimary)),
//                               Text('Plan, discover, ask anything',
//                                   style: TextStyle(
//                                       fontSize: 11, color: NeoTheme.textSecondary)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     NeoBox(
//                       borderRadius: 50,
//                       style: NeoStyle.pressed,
//                       child: Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(28.0),
//                             child: NeoTextField(
//                               hint: 'Plan a 2 day trip around here...',
//                               // leading: Icons.auto_awesome,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // --- Category grid ---
//               GridView.count(
//                 crossAxisCount: 2,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 childAspectRatio: 1.3,
//                 children: [
//                   NeoCategoryTile(
//                     icon: Icons.restaurant,
//                     iconColor: NeoTheme.accentCoral,
//                     label: 'Restaurants',
//                     subtitle: '42 nearby',
//                     onTap: _noop,
//                   ),
//                   NeoCategoryTile(
//                     icon: Icons.terrain,
//                     iconColor: NeoTheme.accentGreen,
//                     label: 'Adventure',
//                     subtitle: '8 nearby',
//                     onTap: _noop,
//                   ),
//                   NeoCategoryTile(
//                     icon: Icons.account_balance,
//                     iconColor: NeoTheme.accentPurple,
//                     label: 'Monuments',
//                     subtitle: '15 nearby',
//                     onTap: _noop,
//                   ),
//                   NeoCategoryTile(
//                     icon: Icons.event,
//                     iconColor: NeoTheme.accentCoral,
//                     label: 'Events',
//                     subtitle: '6 today',
//                     onTap: _noop,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // --- Itinerary status card ---
//               NeoCard(
//                 onTap: _noop,
//                 borderRadius: 45,
//                 child: Row(
//                   children: [
//                     const NeoBox(
//                       style: NeoStyle.pressed,
//                       borderRadius: 28,
//                       width: 52,
//                       height: 52,
//                       child: Icon(Icons.route, size: 22, color: NeoTheme.accentTeal),
//                     ),
//                     const SizedBox(width: 12),
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Your Delhi itinerary',
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w600,
//                                   color: NeoTheme.textPrimary)),
//                           Text('Day 1 of 2 · 5 stops planned',
//                               style: TextStyle(fontSize: 11, color: NeoTheme.textSecondary)),
//                         ],
//                       ),
//                     ),
//                     const Icon(Icons.chevron_right, color: NeoTheme.textSecondary),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       // --- Floating voice button ---
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(right: 0, bottom: 8),
//         child: NeoVoiceButton(
//           state: _voiceState,
//           onHoldStart: _startVoice,
//           onHoldEnd: _stopVoice,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }
//
// void _noop() {}

import 'package:flutter/material.dart';
import '../widgets/neo_widgets.dart';

/// Drop-in demo showing the widget kit assembled into the Xplore home
/// screen from the design mockup. Copy/adapt sections as needed —
/// this file is meant as a working reference, not a fixed final screen.
///
/// Note: the mic/voice button used to live here as a floating action
/// button, but it's now merged into the shared bottom nav bar (see
/// RootShell) so it's available from every tab, not just this one.
class HomeScreenDemo extends StatelessWidget {
  const HomeScreenDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Top bar: location + notifications ---
              Row(
                children: [
                  const NeoIconButton(
                    icon: Icons.location_on,
                    iconColor: NeoTheme.accentPurple,
                    onTap: _noop,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Exploring near',
                            style: TextStyle(fontSize: 12, color: NeoTheme.textSecondary)),
                        Text('Connaught Place, Delhi',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: NeoTheme.textPrimary)),
                      ],
                    ),
                  ),
                  NeoIconButton(icon: Icons.notifications_none, onTap: _noop),
                ],
              ),
              const SizedBox(height: 18),

              // --- AI assistant card with search + voice ---
              // NeoCard(
              //   borderRadius: 36,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           const NeoBox(
              //             style: NeoStyle.pressed,
              //             borderRadius: 17,
              //             width: 34,
              //             height: 34,
              //             child: Icon(Icons.auto_awesome,
              //                 size: 15, color: NeoTheme.accentPurple),
              //           ),
              //           const SizedBox(width: 8),
              //           const Expanded(
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text('Ask Xplore AI',
              //                     style: TextStyle(
              //                         fontSize: 15,
              //                         fontWeight: FontWeight.w600,
              //                         color: NeoTheme.textPrimary)),
              //                 Text('Plan, discover, ask anything',
              //                     style: TextStyle(
              //                         fontSize: 12, color: NeoTheme.textSecondary)),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 12),
              //       NeoBox(
              //         borderRadius: 50,
              //         style: NeoStyle.pressed,
              //         child: Column(
              //           children: [
              //             ClipRRect(
              //               borderRadius: BorderRadius.circular(28.0),
              //               child: NeoTextField(
              //                 hint: 'Plan a 2 day trip around here...',
              //                 leading: Icons.travel_explore_outlined,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 16),

              // --- Category grid ---
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  NeoCategoryTile(
                    icon: Icons.restaurant,
                    iconColor: NeoTheme.accentCoral,
                    label: 'Restaurants',
                    subtitle: '42 nearby',
                    onTap: _noop,
                  ),
                  NeoCategoryTile(
                    icon: Icons.terrain,
                    iconColor: NeoTheme.accentGreen,
                    label: 'Adventure',
                    subtitle: '8 nearby',
                    onTap: _noop,
                  ),
                  NeoCategoryTile(
                    icon: Icons.visibility_outlined,
                    iconColor: NeoTheme.accentPurple,
                    label: 'Sightseeing',
                    subtitle: '15 nearby',
                    onTap: _noop,
                  ),
                  NeoCategoryTile(
                    icon: Icons.event,
                    iconColor: NeoTheme.accentCoral,
                    label: 'Events',
                    subtitle: '6 today',
                    onTap: _noop,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Itinerary status card ---
              NeoCard(
                onTap: _noop,
                borderRadius: 45,
                child: Row(
                  children: [
                    const NeoBox(
                      style: NeoStyle.pressed,
                      borderRadius: 36,
                      width: 52,
                      height: 52,
                      child: Icon(Icons.route, size: 22, color: NeoTheme.accentTeal),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Delhi itinerary',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: NeoTheme.textPrimary)),
                          Text('Day 1 of 2 · 5 stops planned',
                              style: TextStyle(fontSize: 12, color: NeoTheme.textSecondary)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: NeoTheme.textSecondary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: null,
      //   elevation: 0,
      //   backgroundColor: NeoTheme.background,
      //   child: Text('Talk to Xplore AI', style: TextStyle(foreground: Paint()
      //     ..shader = const LinearGradient(
      //       colors: [Colors.purple, Colors.indigo, Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.red],
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //     ).createShader(
      //       const Rect.fromLTWH(0.0, 0.0, 300.0, 50.0), // Hardcoded bounding box (X, Y, Width, Height)
      //     ),
      //   ),
      //     textAlign: TextAlign.center,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

void _noop() {}
