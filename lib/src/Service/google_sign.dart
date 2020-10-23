import 'package:designui/src/Model/userDAO.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSign{
  // user click login
  static Future<String> onSignInFinished(FirebaseUser user) async {
    // get token in firebase
    IdTokenResult fbTokenResult = await user.getIdToken(refresh: true);
    String fbToken = fbTokenResult.token;
    // user show status token
    String status = await UserDao.login(fbToken: fbToken);
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

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    return user;
  }

  static signOutGoogle(GoogleSignIn googleSignIn) async {
    await googleSignIn.signOut();
    print("User Sign Out");
  }


}