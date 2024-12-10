import 'dart:async';
import 'dart:convert';
import 'package:deliveryapplication_mobile_customer/controller/user_controller.dart';
import 'package:deliveryapplication_mobile_customer/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/home_controller.dart';
import '../controller/order_controller.dart';
import '../controller/orderprocessing_controller.dart';
import '../ultilities/Constant.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber;

  VerificationPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String? phoneNumber;
  String? otp;
  bool isLoading = false;
  int _start = 30;
  bool _isButtonDisabled = true;
  late Timer _timer;

  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phoneNumber;
    startTimer();
  }


  void startTimer() {
    _start = 30;
    _isButtonDisabled = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start == 0) {
          _isButtonDisabled = false;
          _timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }


  void _nextField(String value, int currentIndex) {
    if (value.length == 1 && currentIndex < 5) {
      _focusNodes[currentIndex + 1].requestFocus();
    } else if (value.isEmpty && currentIndex > 0) {
      _focusNodes[currentIndex - 1].requestFocus();
    }
  }


  Future<void> verify(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse(Constant.VERIFY_OTP_URL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'phoneNumber': phoneNumber,
        'otp' : otp,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['code'] == 1000) {
        if (responseData['result']['status'] == 'approved') {
          String token = responseData['result']['token'];
          print("Token: $token");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);

          UserController userController = Get.find();
          await userController.fetchUserInfo();
          Get.put(HomeController());
          //Get.put(NotificationController());
          Get.put(OrderProcessingController());
          Get.put(OrderController());
          Get.offAll(HomePage());
        } else if (responseData['result']['status'] == 'pending') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Try again')),
          );
        } else if (responseData['result']['status'] == 'decline') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid Code')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error occurred')),
        );
      }
    }
  }


  Future<void> resend(BuildContext context) async {
    print(phoneNumber);
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/nserve/auth/generateOTP'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'phoneNumber': phoneNumber,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['code'] == 1000) {
        // Successful response
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationPage(phoneNumber: phoneNumber!,),
          ),
        );
      } else {
        // Handle other responses if necessary
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error occurred')),
        );
      }
    } else if (response.statusCode == 404) {
      // Handle response errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid Phone')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the 6-digit code sent to your phone',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) => _nextField(value, index), // Chuyển focus khi nhập
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),


            _isButtonDisabled
                ? Text(
              "Resend code in $_start seconds",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            )
                : TextButton(
              onPressed: () {
                startTimer();
                resend(context);
                print("Resend code");
              },
              child: Text(
                'Resend Code',
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
            SizedBox(height: 20),

            // Nút Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : () {
                  otp = _controllers.map((controller) => controller.text).join();
                  print("Submit verification code: $otp");
                  print(phoneNumber);
                  verify(context);
                },
                child: isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF39c5c8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
