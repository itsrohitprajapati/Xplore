import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/neo_widgets.dart';

/// Profile screen — avatar header, quick stats, and a settings list.
/// Avatar/name now reflect the actual signed-in Firebase user, and
/// "Log out" performs a real sign-out via AuthService instead of a no-op.
class ProfileScreenDemo extends StatelessWidget {
  const ProfileScreenDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;
    final displayName = user?.displayName ?? 'Explorer';
    final photoUrl = user?.photoURL;
    final joinDate = user?.metadata.creationTime;
    final joinLabel = joinDate != null
        ? 'Exploring since ${_monthLabel(joinDate.month)} ${joinDate.year}'
        : '';

    return Scaffold(
      backgroundColor: NeoTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Avatar + name ---
              Center(
                child: Column(
                  children: [
                    NeoBox(
                      style: NeoStyle.raised,
                      borderRadius: 50,
                      width: 88,
                      height: 88,
                      depth: 1.1,
                      child: photoUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person,
                                        size: 40, color: NeoTheme.accentPurple),
                              ),
                            )
                          : const Icon(Icons.person,
                              size: 40, color: NeoTheme.accentPurple),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      displayName,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600, color: NeoTheme.textPrimary),
                    ),
                    if (joinLabel.isNotEmpty)
                      Text(
                        joinLabel,
                        style: const TextStyle(fontSize: 12, color: NeoTheme.textSecondary),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Quick stats row ---
              Row(
                children: [
                  Expanded(child: _StatCard(value: '24', label: 'Trips planned')),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(value: '118', label: 'Places visited')),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(value: '4.8', label: 'Avg rating')),
                ],
              ),
              const SizedBox(height: 20),

              // --- Settings list ---
              NeoCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    _SettingsRow(icon: Icons.person_outline, label: 'Edit profile', onTap: () {}),
                    _divider(),
                    _SettingsRow(
                        icon: Icons.route_outlined, label: 'My itineraries', onTap: () {}),
                    _divider(),
                    _SettingsRow(
                        icon: Icons.favorite_border, label: 'Saved places', onTap: () {}),
                    _divider(),
                    _SettingsRow(
                      icon: Icons.mic_none,
                      label: 'Voice assistant settings',
                      onTap: () {},
                    ),
                    _divider(),
                    _SettingsRow(
                        icon: Icons.notifications_none, label: 'Notifications', onTap: () {}),
                    _divider(),
                    _SettingsRow(icon: Icons.settings_outlined, label: 'App settings', onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              NeoButton(
                onPressed: () async {
                  await authService.signOut();
                  // No manual navigation needed — AuthGate listens to
                  // authStateChanges and will swap to LoginScreen itself.
                },
                width: double.infinity,
                child: const Text(
                  'Log out',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: NeoTheme.accentRed),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Divider(height: 1, color: NeoTheme.shadowDark),
      );
}

String _monthLabel(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return months[(month - 1).clamp(0, 11)];
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      style: NeoStyle.raised,
      borderRadius: NeoTheme.radiusMd,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: NeoTheme.textPrimary)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: NeoTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            NeoBox(
              style: NeoStyle.pressed,
              borderRadius: 12,
              width: 34,
              height: 34,
              child: Icon(icon, size: 16, color: NeoTheme.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 13, color: NeoTheme.textPrimary)),
            ),
            const Icon(Icons.chevron_right, size: 18, color: NeoTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}
