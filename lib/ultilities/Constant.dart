import 'dart:ui';

class Constant {

  // ignore: constant_identifier_names
  static const BACKEND_URL = "http://10.0.2.2:8080/nserve";

  // ignore: constant_identifier_names
  static const GENERATE_OTP_URL = "$BACKEND_URL/auth/generateOTP";

  // ignore: constant_identifier_names
  static const GENERATE_OTP_CUSTOMER_URL = "$BACKEND_URL/auth/customer/generateOTP";

  // ignore: constant_identifier_names
  static const VERIFY_OTP_URL = "$BACKEND_URL/auth/verifyOTP";

  // ignore: constant_identifier_names
  static const IMAGE_URL = "$BACKEND_URL/images/";

  // ignore: constant_identifier_names
  static const LOGOUT_URL = "$BACKEND_URL/auth/logout";

  // ignore: constant_identifier_names
  static const INTROSPECT_URL = "$BACKEND_URL/auth/introspect";

  // ignore: constant_identifier_names
  static const RESTAURANT_URL = "$BACKEND_URL/restaurants";

  // ignore: constant_identifier_names
  static const REGISTER_CUSTOMER_URL = "$BACKEND_URL/users/registerCustomer";

  // ignore: constant_identifier_names
  static const UPDATE_CUSTOMER_URL = "$BACKEND_URL/users/updateCustomer";

  // ignore: constant_identifier_names
  static const DRIVER_URL = "$BACKEND_URL/drivers";

  // ignore: constant_identifier_names
  static const ORDER_DRIVER_URL = "$ORDER_URL/driver";

  // ignore: constant_identifier_names
  static const ORDER_CUSTOMER_URL = "$ORDER_URL/customer";

  // ignore: constant_identifier_names
  static const CATEGORY_URL = "$BACKEND_URL/categories";

  // ignore: constant_identifier_names
  static const FOOD_URL = "$BACKEND_URL/foods";

  // ignore: constant_identifier_names
  static const ORDER_URL = "$BACKEND_URL/orders";

  // ignore: constant_identifier_names
  static const CREATE_ORDER_URL = "$ORDER_URL/createOrder";

  // ignore: constant_identifier_names
  static const USER_URL = "$BACKEND_URL/users";

  // ignore: constant_identifier_names
  static const ORDER_RESTAURANT_URL = "$BACKEND_URL/orders/restaurant";

  // ignore: constant_identifier_names
  static const USER_INFO_URL = "$USER_URL/info";

  // ignore: constant_identifier_names
  static const SHIPPING_FEE_URL = "$BACKEND_URL/orders/calculate-shipping-fee";

  // ignore: constant_identifier_names
  static const WEBSOCKET_URL = "$BACKEND_URL/ws";

  // ignore: constant_identifier_names
  static const IMG_URL = "https://res.cloudinary.com/dsdowcig9";

  static const JWT = "eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJxbmdvYzA3MDEyMDAyIiwic3ViIjoiOTQwZjJlM2ItNDY1Yi00ZjI1LWIzNTQtZDM2YWUxOGZiZjMyIiwiZXhwIjoxNzQxODU2NTgwLCJpYXQiOjE3MzM4NTY1ODAsImp0aSI6IjA4NmJiMTFlLTRlNmItNGM1ZC05NzgyLWExMmFjMjk5NzkwNCIsInNjb3BlIjoiIn0.6zk-6d_rwH3dDCdZwxhS_QBdraFC0Hh9cPY5MeULniNXzipHocemYbQ-odhwStbdPVID25Rtr0Bzn2EVXHeYdA";

  static const stripePublishableKey = "pk_test_51MPfTSA5vKPlbljEeTnHusfYFriKpHPpUJe0KNQIc9xB638GPdWRWO5RnzrLBeD6Am9NInVocj4AtJKSBUUA9GS700cQv3HfFQ";

  static const stripeSecretKey = "sk_test_51MPfTSA5vKPlbljExViQrrELBRTDDeoi3UskDs4Auz0eRsv7NwqzzcRjVpD2viglbbfsSnEcGGVXWIm2eWqRZXBD00bCckigP8";
  //Nếu là Emulator ở máy thì dùng 10.0.2.2 nếu ngoài thì vào ipconfig check ipv4
}