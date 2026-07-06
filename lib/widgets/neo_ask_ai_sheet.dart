import 'package:flutter/material.dart';

import 'neo_widgets.dart';

/// Shows the "Ask Xplore AI" card as a modal bottom sheet, so it can be
/// triggered from anywhere (e.g. a quick tap on the mic button in the
/// bottom nav) instead of only living inline on the Discover screen.
///
/// Usage:
/// ```dart
/// showAskAiSheet(context);
/// ```
Future<void> showAskAiSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const _AskAiSheet(),
  );
}

class _AskAiSheet extends StatelessWidget {
  const _AskAiSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Lifts the sheet above the keyboard when the text field is focused.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: NeoTheme.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle.
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: NeoTheme.shadowDark,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // Same "Ask Xplore AI" card used on the Discover screen.
            NeoCard(
              borderRadius: 36,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const NeoBox(
                        style: NeoStyle.pressed,
                        borderRadius: 17,
                        width: 34,
                        height: 34,
                        child: Icon(Icons.auto_awesome,
                            size: 15, color: NeoTheme.accentPurple),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ask Xplore AI',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: NeoTheme.textPrimary)),
                            Text('Plan, discover, ask anything',
                                style: TextStyle(
                                    fontSize: 11, color: NeoTheme.textSecondary)),
                          ],
                        ),
                      ),
                      NeoIconButton(
                        icon: Icons.close,
                        size: 34,
                        iconSize: 16,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  NeoBox(
                    borderRadius: 50,
                    style: NeoStyle.pressed,
                    child: NeoTextField(
                      hint: 'Plan a 2 day trip around here...',
                      trailing: Icons.send,
                      onTrailingTap: () {
                        // TODO: send the query to your AI backend.
                      },
                      onSubmitted: (_) {
                        // TODO: send the query to your AI backend.
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
