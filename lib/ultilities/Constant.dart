import 'dart:ui';

class Constant {

  // ignore: constant_identifier_names
  static const BACKEND_URL = "http://10.0.2.2:8080/nserve";

  // ignore: constant_identifier_names
  static const GENERATE_OTP_URL = "$BACKEND_URL/auth/generateOTP";

  // ignore: constant_identifier_names
  static const VERIFY_OTP_URL = "$BACKEND_URL/auth/verifyOTP";

  // ignore: constant_identifier_names
  static const IMAGE_URL = "$BACKEND_URL/images/";

  // ignore: constant_identifier_names
  static const RESTAURANT_URL = "$BACKEND_URL/restaurants";

  // ignore: constant_identifier_names
  static const CATEGORY_URL = "$BACKEND_URL/categories";

  // ignore: constant_identifier_names
  static const FOOD_URL = "$BACKEND_URL/foods";

  // ignore: constant_identifier_names
  static const ORDER_URL = "$BACKEND_URL/orders";

  // ignore: constant_identifier_names
  static const SHIPPING_FEE_URL = "$BACKEND_URL/orders/calculate-shipping-fee";

  // ignore: constant_identifier_names
  static const WEBSOCKET_URL = "$BACKEND_URL/ws";

  // ignore: constant_identifier_names
  static const IMG_URL = "https://res.cloudinary.com/dsdowcig9";

  static const JWT = "eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJxbmdvYzA3MDEyMDAyIiwic3ViIjoiOTQwZjJlM2ItNDY1Yi00ZjI1LWIzNTQtZDM2YWUxOGZiZjMyIiwiZXhwIjoxNzMxNTQxMDY4LCJpYXQiOjE3MzE1Mzc0NjgsImp0aSI6ImM1ZWQxMzQ5LTBkYjMtNDUxZS1iMWZjLTEzMmMzYWMxZGNlYiIsInNjb3BlIjoiUk9MRV9EUklWRVIgUk9MRV9DVVNUT01FUiBST0xFX0FETUlOIFJPTEVfUkVTVEFVUkFOVCJ9.bMdphBOke3dEOW9M9Zy0lVtF4XPPEHU5yf41m2K8wOf7u1xrIJnx3_Zql8d6iUXDcGeprGQbHUo_pxBYGs3FSA";


  //Nếu là Emulator ở máy thì dùng 10.0.2.2 nếu ngoài thì vào ipconfig check ipv4
}