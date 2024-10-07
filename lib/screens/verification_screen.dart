import 'dart:async';
import 'package:deliveryapplication_mobile_customer/screens/homepage_screen.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  int _start = 30;
  bool _isButtonDisabled = true;
  late Timer _timer;

  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
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
                onPressed: () {

                  String otpCode = _controllers.map((controller) => controller.text).join();
                  print("Submit verification code: $otpCode");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: Text('Submit', style: TextStyle(fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF39c5c8),

                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
