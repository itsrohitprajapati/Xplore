import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Thin wrapper around Firebase Auth + Google Sign-In.
///
/// This is the single place that talks to both SDKs — screens should only
/// ever call [AuthService], never `FirebaseAuth.instance` or
/// `GoogleSignIn()` directly, so the sign-in flow stays consistent as the
/// app grows (e.g. adding Apple Sign-In later).
///
/// Usage:
/// ```dart
/// final auth = AuthService();
///
/// // Listen for sign-in state changes (drives AuthGate):
/// auth.authStateChanges.listen((user) { ... });
///
/// // Sign in:
/// final user = await auth.signInWithGoogle();
///
/// // Sign out:
/// await auth.signOut();
/// ```
class AuthService {
  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email', 'profile']);

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Emits the current user whenever sign-in state changes (login, logout,
  /// token refresh). Emits `null` when signed out.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// The currently signed-in user, or `null` if nobody is signed in.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Opens the Google account picker, then signs the user into Firebase
  /// with the resulting Google credential.
  ///
  /// Returns the signed-in [User], or `null` if the user cancelled the
  /// Google account picker.
  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // User dismissed the account picker — not an error.
      return null;
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  /// Signs out of both Firebase and the Google account picker, so the next
  /// sign-in shows the account chooser again instead of silently
  /// re-authenticating the same account.
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
