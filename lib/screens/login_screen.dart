import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/neo_widgets.dart';

/// Login screen shown when no user is signed in (see AuthGate).
/// Single "Continue with Google" action — matches the app's neomorphic
/// styling rather than using Google's default branded button widget.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  bool _loading = false;
  String? _errorMessage;

  Future<void> _handleSignIn() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.signInWithGoogle();
      // If user is null, they just cancelled the picker — nothing to do,
      // AuthGate will keep showing this screen either way.
      if (user == null && mounted) {
        setState(() => _loading = false);
      }
      // On success, AuthGate's authStateChanges listener handles
      // navigation automatically — no need to navigate manually here.
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = 'Sign-in failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const NeoBox(
                style: NeoStyle.raised,
                borderRadius: 60,
                width: 120,
                height: 120,
                depth: 1.2,
                child: Icon(Icons.explore, size: 52, color: NeoTheme.accentPurple),
              ),
              const SizedBox(height: 28),
              const Text(
                'Welcome to Xplore',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: NeoTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to plan trips, save places,\nand get AI-powered itineraries.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: NeoTheme.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 40),

              NeoButton(
                onPressed: _loading ? () {} : _handleSignIn,
                width: double.infinity,
                borderRadius: 28,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: NeoTheme.accentPurple,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // NeoBox(
                          //   style: NeoStyle.pressed,
                          //   borderRadius: 12,
                          //   width: 26,
                          //   height: 26,
                          //   depth: 0.6,
                          //   child: const Text(
                          //     'G',
                          //     style: TextStyle(
                          //       fontSize: 15,
                          //       fontWeight: FontWeight.w700,
                          //       color: NeoTheme.accentPurple,
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(width: 10),
                          const Text(
                            'Continue with ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: NeoTheme.textPrimary,
                            ),
                          ),
                          // const SizedBox(width: 10),
                          const Text(
                            'G',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          // const SizedBox(width: 10),
                          const Text(
                            'o',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          // const SizedBox(width: 10),
                          const Text(
                            'o',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber,
                            ),
                          ),
                          // const SizedBox(width: 10),
                          const Text(
                            'g',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          // const SizedBox(width: 10),
                          const Text(
                            'l',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          // const SizedBox(width: 10),
                          const Text(
                            'e',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: const TextStyle(fontSize: 12, color: NeoTheme.accentRed),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
