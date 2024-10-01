class AppConstants {
  static const String APP_NAME = "DBFood";
  static const int APP_VERSION = 1;
  static const String BASE_URL ="http://192.168.141.113:8000";
  static const String POPULAR_PRODUCT_URI ="/api/v1/products/popular";
  static const String RECOMMENDED_PRODUCT_URI ="/api/v1/products/recommended";
  
  static const String IMAGE_UPLOADS_URL = "http://192.168.141.113:8000/uploads/";
  static const String CART_LIST = "cart-list";
  static const String CART_HISTORY_LIST = "cart-history-list";
  static const String REGISTRATION_URi="/api/v1/auth/register";
  static const String LOGIN_URi="/api/v1/auth/login";
  static const String USRER_INFO="/api/v1/customer/info";

  //addRS User
  static const String USER_ADDRESS="user_Address";
  static const String GEOCODE_URI="/api/v1/customer/config/geocode";
  static const String ADD_USER_ADDRESS='/api/v1/customer/address/add';
   static const String ADD_LIST_URI='/api/v1/customer/address/list';
   static const String ZONE_URI='/api/v1/config/get-zone-id';


   //payment
    static const String PAYEMENT_URI='order/show';
    //REPORT
    static const String REPORT_URI="/api/v1/customer/report";

    //orders

    static String PLACE_ORDER_URI='/api/v1/customer/order/place';
    static String ORDER_LIST='/api/v1/customer/order/list';



  
  static const String TOKEN = "";
  static const String PHONE = "";
  static const String PASSWORD = "";

   static const String TOKEN_URI="/api/v1/customer/cm-firebase-token";

}