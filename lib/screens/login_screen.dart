import 'dart:convert';
import 'package:deliveryapplication_mobile_customer/screens/register_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;

import '../controller/user_controller.dart';
import '../ultilities/Constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserController userController = Get.find();
  final TextEditingController phoneController = TextEditingController();
  String? phoneNumber;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userController.checkTokenValidity();
  }

  Future<void> login(BuildContext context) async {
    print(phoneNumber);
    setState(() {
      isLoading = true;
    });
    userController.phoneNumber.value = phoneNumber!;
    final response = await http.post(
      Uri.parse(Constant.GENERATE_OTP_CUSTOMER_URL),
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
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {

      if (responseData['code'] == 1000) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationPage(phoneNumber: phoneNumber!,),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error occurred')),
        );
      }
    } else if (response.statusCode == 404) {
      if (responseData['code'] == 1002){
        Get.to(RegisterPage());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error occurred')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to login. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_login.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 300),
                IntlPhoneField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.disabled,
                  initialCountryCode: 'VN',
                  onChanged: (phone) {
                    print(phone.completeNumber);
                    phoneNumber = phone.completeNumber;
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () {
                      login(context);
                      print("Login button pressed");
                    },
                    child: isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text(
                      'Login',
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
        ],
      ),
    );
  }
}


// class LoginPage extends StatelessWidget {
//   final TextEditingController phoneController = TextEditingController();
//   String? phoneNumber;
//   Future<void> login(BuildContext context) async {
//     print(phoneNumber);
//
//
//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:8080/nserve/auth/generateOTP'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({
//         'phoneNumber': phoneNumber,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       if (responseData['code'] == 1000) {
//         // Successful response
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => VerificationPage(),
//           ),
//         );
//       } else {
//         // Handle other responses if necessary
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Unexpected error occurred')),
//         );
//       }
//     } else if (response.statusCode == 404) {
//       // Handle response errors
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Invalid Phone')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/background_login.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           // Login form
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: 300),
//                 IntlPhoneField(
//                   controller: phoneController, // Add controller
//                   decoration: InputDecoration(
//                     labelText: 'Phone Number',
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.8),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(),
//                     ),
//                   ),
//                   autovalidateMode: AutovalidateMode.disabled,
//                   initialCountryCode: 'VN',
//                   onChanged: (phone) {
//                     print(phone.completeNumber);
//                     phoneNumber = phone.completeNumber;
//                   },
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       login(context); // Call login method
//                       print("Login button pressed");
//                     },
//                     child: Text(
//                       'Login',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 17,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF39c5c8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 15),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
