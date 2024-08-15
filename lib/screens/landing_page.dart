import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image.asset("assets/images/thumbnail.png"),
            SizedBox(
              height: 100,
            ),
            Row(

              children: [

                Text("1234"),

                ElevatedButton(onPressed: (){

                }, child: Text("ABC"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
