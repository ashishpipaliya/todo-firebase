import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  static final AuthService _instance = AuthService._internal();

  static AuthService get instance => _instance;

  AuthService._internal();

//  Login
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      } else {
        throw Exception("Cancelled By User");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  // Sign Out
  Future signOut() async {
    try {
      await googleSignIn.disconnect();
      _auth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  // on auth change
  Stream<User?> get userLoginState => _auth.authStateChanges();

  User? get user => _auth.currentUser;
}
