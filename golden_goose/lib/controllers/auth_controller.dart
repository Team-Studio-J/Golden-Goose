import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/screens/login.dart';
import 'package:golden_goose/screens/splash.dart';
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
    // auth is coming from the constants.dart file but it is basically FirebaseAuth.instance.
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

class AuthController extends GetxController {
  final Rx<GoogleSignIn> _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  ).obs;

  final Rx<FirebaseAuth> _auth = FirebaseAuth.instance.obs;
  late Rx<User?> _user;

  User? get user => _user.value;

  bool get isLoggedIn => _user.value != null;

  @override
  void onInit() {
    super.onInit();
    _user = Rx<User?>(_auth.value.currentUser);
    _user.bindStream(_auth.value.userChanges());

    ever(_user, _bindOrLoggedOut);
  }

  _bindOrLoggedOut(_) {
    if (!isLoggedIn) {
      if (Get.currentRoute == "/" ||
          Get.currentRoute == Login.path ||
          Get.currentRoute == Splash.path) {
        return;
      }
      Get.delete<UserController>();
      Get.offAll(() => Login());
    } else {
      Get.put(UserController(), permanent: true);
      Get.find<UserController>().bindUser();
    }
  }

  Future googleLogin() async {
    final googleUser = await _googleSignIn.value.signIn();
    if (googleUser == null) {
      Get.snackbar("Login Failed".tr, "Login is not successful".tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.value.signInWithCredential(credential);
    Get.snackbar("Login Succeeded".tr, "Successfully Logged In".tr,
        snackPosition: SnackPosition.BOTTOM);
  }

  Future signOut() async {
    try {
      if (!isLoggedIn) return;
      await _auth.value.signOut();
      await _googleSignIn.value.signOut();
      Get.snackbar("Logout Succeeded".tr, "Successfully Logged Out".tr,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error on signout".tr, "", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
