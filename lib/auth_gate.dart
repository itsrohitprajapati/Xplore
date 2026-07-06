import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xplore/root_shell.dart';
import 'package:xplore/screens/login_screen.dart';
import 'package:xplore/services/auth_service.dart';
import 'package:xplore/widgets/neo_widgets.dart';

/// Sits at the root of the app (below MaterialApp) and switches between
/// [LoginScreen] and [RootShell] based on Firebase auth state — so no
/// screen needs to manually navigate on login/logout, it just happens
/// reactively whenever [AuthService.authStateChanges] fires.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: NeoTheme.background,
            body: Center(
              child: CircularProgressIndicator(color: NeoTheme.accentPurple),
            ),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        }
        return const RootShell();
      },
    );
  }
}
