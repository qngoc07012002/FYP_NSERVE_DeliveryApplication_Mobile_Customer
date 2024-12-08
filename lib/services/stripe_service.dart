import 'package:deliveryapplication_mobile_customer/controller/food_controller.dart';
import 'package:deliveryapplication_mobile_customer/controller/notification_controller.dart';
import 'package:deliveryapplication_mobile_customer/ultilities/Constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class StripeService {
  StripeService._();

  static final StripeService instance =  StripeService._();

  Future<bool> makePayment() async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(10, "usd");
      if (paymentIntentClientSecret  == null) return false;
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: "NSERVE",
          ));
      try {
        await Stripe.instance.presentPaymentSheet();
        Get.snackbar("Payment", "Paid successfully");
        return true;

      } on StripeException catch (e) {
        print('Error: $e');
        return false;
      } catch (e) {
        print("Error in displaying");
        print('$e');
        return false;
      }

    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };
      var response = await dio.post(
          "https://api.stripe.com/v1/payment_intents",
          data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
            headers: {
            "Authorization": "Bearer ${Constant.stripeSecretKey}",
            "Content-Type" : "application/x-www-form-urlencoded",
        }
        )
      );

      if (response.data != null) {

        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Future<bool> _processPayment() async {
  //
  // }

  String _calculateAmount(int amount){
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}