class Url {
  static String _key = "";
  static const storageUrl =
      "https://ngtestnode.firebaseio.com/shop_app_products";
  static const ordersUrl = "https://ngtestnode.firebaseio.com/shop_app_orders";
  static const favUrl = "https://ngtestnode.firebaseio.com/shop_app_user_fav";
  static String firebaseSignup =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_key";
  static String firebaseSignin =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_key";
}
