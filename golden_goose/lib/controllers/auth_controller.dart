import 'package:firebase_auth/firebase_auth.dart';
import 'package:golden_goose/screens/home_depre2.dart';
import 'package:golden_goose/screens/login_depre2.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

/*
class GetAuthController extends GetxController {
  static GetAuthController authInstance = Get.find();
  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    print("On Ready");
    //ever(firebaseUser, (firebaseUser) { _setInitialScreen(firebaseUser)});
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    print("firebaseUser Changed");
    if (user != null){
      Get.offAll(() => const Home());
      Get.snackbar("Golden Goose", "Welcome! ${user.email}", snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.offAll(() => Login());
    }
  }

  Future register(String email, password) async {
    try {
      print("try register 1");
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("catch register 1");
      Get.snackbar("Golden Goose", e.toString());
    } catch(e) {
      print("catch register 2");
      Get.snackbar("Golden Goose", e.toString());
    }
  }

  Future login(String email, password) async {
    try {
      print("try login 1");
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("catch login 1");
      Get.snackbar("Golden Goose", e.toString());
    } catch(e) {
      print("catch login 2");
      Get.snackbar("Golden Goose", e.toString());
    }
  }

  Future signOut() async {
    try {
      print("try signOut 1");
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      print("catch signout 1");
      Get.snackbar("Golden Goose", e.toString());
    } catch(e) {
      print("catch signout 2");
      Get.snackbar("Golden Goose", e.toString());
    }
  }
}

 */

/*
class GetAuthController extends GetxController {
  static GetAuthController instance = Get.find();
  late Rx<User?> firebaseUser;

  Rx<GoogleSignInAccount?> googleSignInAccount = null.obs;

  User? get user => firebaseUser.value;

  @override
  void onReady() {
    super.onReady();
    // auth is comning from the constants.dart file but it is basically FirebaseAuth.instance.
    // Since we have to use that many times I just made a constant file and declared there

    firebaseUser = Rx<User?>(auth.currentUser);
    googleSignInAccount = Rx<GoogleSignInAccount?>(googleSign.currentUser);


    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, (_) => print("test1"));


    googleSignInAccount.bindStream(googleSign.onCurrentUserChanged);
    ever(googleSignInAccount, (_) => print("test2"));
  }

  void googleLogin() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSign.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await auth
            .signInWithCredential(credential)
            .catchError((onErr) => print(onErr));
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      print(e.toString());
    }
  }

  void createUser(String email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (firebaseAuthException) {}
  }

  void login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (firebaseAuthException) {}
  }

  void signOut() async {
    await auth.signOut();
  }
}

 */


class GetAuthController extends GetxController {
  final Rx<GoogleSignIn> _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  ).obs;

  Rx<FirebaseAuth> _auth = FirebaseAuth.instance.obs;
  late Rx<User?> _user;

  // User? user = FirebaseAuth.instance.currentUser;
  //User? get user => _auth.value.currentUser;
  User? get user => _user.value;


  @override
  void onInit() {
    super.onInit();
    _user = Rx<User?>(_auth.value.currentUser);
    _user.bindStream(_auth.value.userChanges());

    ever(_user, (_) {print("user changed");});
    ever(_googleSignIn, (_) {print("googlesignin changed");});
  }

  Future googleLogin() async {
    print("Google Login0");
    final googleUser = await _googleSignIn.value.signIn();
    if (googleUser == null) {
      Get.snackbar("Golden Goose", "Not Logged in by Google");
      return;
    }
    print("Google Login1");
    final googleAuth = await googleUser.authentication;
    print("Google Login2");
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("Google Login3");

    await _auth.value.signInWithCredential(credential);
    print("Google Login4");
    Get.snackbar("Golden Goose", "Successfully Logged in by Google", snackPosition: SnackPosition.BOTTOM );
    update();
  }

  void createUser(String email, String password) async {
    await _auth.value.createUserWithEmailAndPassword(email: email, password: password);
    try {
    } catch (e) {
      Get.snackbar( "Error creating account", "", snackPosition: SnackPosition.BOTTOM );
    }
  }
  Future login(String email, String password) async {
    await _auth.value.signInWithEmailAndPassword(email: email, password: password);
    try {
    } catch(e) {
      Get.snackbar( "Error login account", "", snackPosition: SnackPosition.BOTTOM );
    }
  }
  void signOut() async {
    try {
      await _auth.value.signOut();
      await _googleSignIn.value.signOut();
      update();
    } catch(e) {
      Get.snackbar( "Error signout", "", snackPosition: SnackPosition.BOTTOM );
    }
  }
}

