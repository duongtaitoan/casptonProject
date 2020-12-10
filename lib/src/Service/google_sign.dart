import 'package:designui/src/Model/userDAO.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSign {
  // get length of token and content
  static void logLongString(String s) {
    if (s == null || s.length <= 0) return;
    const int n = 1000;
    int startIndex = 0;
    int endIndex = n;
    print("ID Length: " + s.length.toString());
    while (startIndex < s.length) {
      if (endIndex > s.length) endIndex = s.length;
      print("Length: " + endIndex.toString());
      print(s.substring(startIndex, endIndex));
      startIndex += n;
      endIndex = startIndex + n;
    }
  }
  // user click login
  static Future<String> onSignInFinished(FirebaseUser user) async {
    String status;
      // get token in firebase
    IdTokenResult fbTokenResult = await user.getIdToken(refresh: true);
    String fbToken = fbTokenResult.token;
    logLongString(fbToken);
    // user show status token
    status = await UserDAO.login(fbToken: fbToken, user: user);
    return status;
  }

  // check user by firebase
  static Future<FirebaseUser> handleSignIn() async {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      signOutGoogle(_googleSignIn);
      final FirebaseAuth _auth = FirebaseAuth.instance;

      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication authentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );

      final AuthResult authResult = await _auth.signInWithCredential(
          credential);
      final FirebaseUser user = authResult.user;
      return user;
  }

  static signOutGoogle(GoogleSignIn googleSignIn) async {
    await googleSignIn.signOut();
    print("User Sign Out");
  }
}
