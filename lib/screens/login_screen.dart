import 'package:deliveryapplication_mobile_customer/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hình nền
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_login.png',
              fit: BoxFit.cover,
            ),
          ),

          // Form đăng nhập
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 300,),
                IntlPhoneField(
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
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerificationPage(),
                        ),
                      );
                      print("Login button pressed");
                    },
                    child: Text('Login', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17
                    ),),
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
