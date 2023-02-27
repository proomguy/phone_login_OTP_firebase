import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_login/home_screen.dart';
import 'package:pinput/pin_put/pin_put.dart';


class OTPControllerScreen extends StatefulWidget {

  final String phone;
  final String codeDigits;

  OTPControllerScreen({required this.phone, required this.codeDigits});

  @override
  State<OTPControllerScreen> createState() => _OTPControllerScreenState();
}

class _OTPControllerScreenState extends State<OTPControllerScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPEditingController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();
  String? verificationCode;

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
    color: Colors.greenAccent,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Colors.black,
    )
  );

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${widget.codeDigits + widget.phone}",
      verificationCompleted: (PhoneAuthCredential credential) async{
        await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          if(value.user != null){
            Navigator.of(context).push(MaterialPageRoute(builder: (c) => HomeScreen()));
          }
        });
      },
      verificationFailed: (FirebaseAuthException e){
        print("It just failed");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 3),
          ),
        );
      },
      codeSent: (String vID, int? resendToken){
        setState(() {
          verificationCode = vID;
        });
      },
      codeAutoRetrievalTimeout: (String vID){
        setState(() {
          verificationCode = vID;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("OTP verification"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("images/otp.png"),
          ),
          Container(
            margin: EdgeInsets.only(top: 20,),
            child: Center(
              child: GestureDetector(
                onTap: (){

                  verifyPhoneNumber();

                },
                child: Text(
                  "verifying : ${widget.codeDigits}-${widget.phone}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(40.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinOTPCodeFocus,
              controller: _pinOTPEditingController,
              submittedFieldDecoration: pinOTPCodeDecoration,
              selectedFieldDecoration: pinOTPCodeDecoration,
              followingFieldDecoration: pinOTPCodeDecoration,
              pinAnimationType: PinAnimationType.rotation,
              onSubmit: (pin) async {
                try{
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider
                      .credential(verificationId: verificationCode!, smsCode: pin))
                      .then((value) => {
                        if(value.user != null){
                          Navigator.of(context).push(MaterialPageRoute(builder: (c) => HomeScreen()))
                        }

                  });
                }
                catch(e){
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Invalid OTP"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
