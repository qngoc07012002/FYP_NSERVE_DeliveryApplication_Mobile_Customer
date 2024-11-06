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
  static const IMG_URL = "https://res.cloudinary.com/dsdowcig9";

  static const JWT = "eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJxbmdvYzA3MDEyMDAyIiwic3ViIjoiMTk2NTE3NmEtYzFhOS00NzQ3LWIxMGYtMTRkNGIyMzY1ODdhIiwiZXhwIjoxNzMwNTg1MTYyLCJpYXQiOjE3MzA1ODE1NjIsImp0aSI6IjY4MGYzYTRmLWJiN2UtNDI0ZC1iMzA2LTM4YjNlOGM3MzdjMiIsInNjb3BlIjoiUk9MRV9DVVNUT01FUiBST0xFX1JFU1RBVVJBTlQgUk9MRV9BRE1JTiBST0xFX0RSSVZFUiJ9.JwWdMINAD74nGzovkFPGdZo9ogrF1OPdSHCGAZGhgyaHJFVBEs20UthXtghx5h2QfjfZbQjJ90jXiRnE4gbmwA";


  //Nếu là Emulator ở máy thì dùng 10.0.2.2 nếu ngoài thì vào ipconfig check ipv4
}