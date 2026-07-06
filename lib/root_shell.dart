// import 'package:flutter/material.dart';
// import 'package:projects/screens/home_screen_demo.dart';
// import 'package:projects/screens/profile_screen_demo.dart';
// import 'package:projects/widgets/neo_bottom_nav.dart';
// import '../widgets/neo_widgets.dart';
//
// /// Root shell that hosts the bottom nav bar and switches between tabs.
// /// Replace the placeholder screens (Map, Trips) with your real ones.
// class RootShell extends StatefulWidget {
//   const RootShell({super.key});
//
//   @override
//   State<RootShell> createState() => _RootShellState();
// }
//
// class _RootShellState extends State<RootShell> {
//   int _index = 0;
//
//   static final _items = [
//     NeoNavItem(icon: Icons.explore_outlined, label: 'Discover'),
//     NeoNavItem(icon: Icons.map_outlined, label: 'Map', activeColor: NeoTheme.accentTeal),
//     NeoNavItem(icon: Icons.airplane_ticket_outlined, label: 'Trips', activeColor: NeoTheme.accentCoral),
//     NeoNavItem(icon: Icons.person_outline, label: 'Profile', activeColor: NeoTheme.accentGreen),
//   ];
//
//   final _screens = const [
//     HomeScreenDemo(),
//     _PlaceholderScreen(label: 'Map'),
//     _PlaceholderScreen(label: 'Trips'),
//     ProfileScreenDemo(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: NeoTheme.background,
//       body: IndexedStack(index: _index, children: _screens),
//       bottomNavigationBar: NeoBottomNavBar(
//         items: _items,
//         currentIndex: _index,
//         onTap: (i) => setState(() => _index = i),
//       ),
//     );
//   }
// }
//
// class _PlaceholderScreen extends StatelessWidget {
//   const _PlaceholderScreen({required this.label});
//   final String label;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('$label screen goes here',
//           style: const TextStyle(color: NeoTheme.textSecondary)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:xplore/screens/home_screen_demo.dart';
import 'package:xplore/screens/map_screen_demo.dart';
import 'package:xplore/screens/profile_screen_demo.dart';
import 'package:xplore/widgets/neo_bottom_nav.dart';
import '../widgets/neo_widgets.dart';

/// Root shell that hosts the bottom nav bar and switches between tabs.
/// The mic button now lives here (merged into the nav bar) instead of as
/// a per-screen floating action button, since it needs to be available
/// on every tab, not just Discover.
/// Map tab now shows a live current-location map (see MapScreenDemo).
/// Replace the remaining placeholder screen (Trips) with your real one.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;
  NeoVoiceState _voiceState = NeoVoiceState.idle;

  static final _items = [
    NeoNavItem(icon: Icons.explore_outlined, label: 'Discover'),
    NeoNavItem(icon: Icons.map_outlined, label: 'Map', activeColor: NeoTheme.accentTeal),
    NeoNavItem(icon: Icons.airplane_ticket_outlined, label: 'Trips', activeColor: NeoTheme.accentCoral),
    NeoNavItem(icon: Icons.person_outline, label: 'Profile', activeColor: NeoTheme.accentGreen),
  ];

  final _screens = const [
    HomeScreenDemo(),
    MapScreenDemo(),
    _PlaceholderScreen(label: 'Trips'),
    ProfileScreenDemo(),
  ];

  void _startVoice() {
    setState(() => _voiceState = NeoVoiceState.listening);

    // TODO:
    // await speechToText.listen();
  }

  void _stopVoice() {
    setState(() => _voiceState = NeoVoiceState.idle);

    // TODO:
    // await speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoTheme.background,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NeoBottomNavBar(
        items: _items,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        micState: _voiceState,
        onMicHoldStart: _startVoice,
        onMicHoldEnd: _stopVoice,
        onMicQuickTap: () => showAskAiSheet(context),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$label screen goes here',
          style: const TextStyle(color: NeoTheme.textSecondary)),
    );
  }
}
