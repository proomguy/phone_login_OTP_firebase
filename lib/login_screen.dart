import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:phone_login/OTPController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String dialCodeDigits = "+00";
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0),
              child: Image.asset(
                "images/login.jpg"
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Center(
                child: Text(
                  "Phone (OTP) Authentication",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,),
            SizedBox(
              width: 400,
              height: 60,
              child: CountryCodePicker(
                onChanged: (country){
                  setState(() {
                    dialCodeDigits = country.dialCode!;
                  });
                },
                initialSelection: "IT",
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                favorite: ["+254","KE", "1", "US","+92","PAK"],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  prefix: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(dialCodeDigits),
                  ),
                ),
                maxLength: 12,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){

                  Navigator.of(context).push(MaterialPageRoute(builder: (c) => OTPControllerScreen(
                    phone: _controller.text,
                    codeDigits: dialCodeDigits,
                  )));

                },
                child: Text("Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
