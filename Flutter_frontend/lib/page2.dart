import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeeasy2/Reset_pass/Reset_pass_model.dart';
import 'package:gradeeasy2/confirm_pass/Confirm_pass_api_service.dart';
import 'package:gradeeasy2/confirm_pass/Confirm_pass_model.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import 'Outlinebutton.dart';
import 'ProjectHUD.dart';
import 'Reset_pass/Reset_api_service.dart';

String reset_token;

class stack2 extends StatefulWidget {


  @override
  _stack2State createState() => _stack2State();
}

class _stack2State extends State<stack2> {
  int _pagestate = 1;
  bool isApiCallProcess_reset = false;
  bool isApiCallProcess = false;
  bool isApiCallProcess_confirmpass = false;
  var myController = TextEditingController();
  var new_pass = TextEditingController();
  var confirm_pass = TextEditingController();
  var con_pass = TextEditingController();

  var _bgcolor = Colors.white;
  var _headingcolor = Colors.white;
  bool result = false;
  GlobalKey<FormState> globalFormKey_login = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  GlobalKey<FormState> globalFormKey_reset = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  GlobalKey<FormState> globalFormKey_confirmpass = GlobalKey<FormState>();
  ResetRequestModel resetRequestModel;
  ConfirmpassRequestModel confirmpassRequestModel;
  double _fpass_height = 0, _fpass_width = 0;
  double _fpass_xoffset = 0, _fpass_yoffset = 0;
  double _fpass_container_opacity = 1;

  double reset_height =0;
  double reset_yoffset =0;
  double winwidth = 0;
  double winheight = 0;


  double _headingtop = 75;
  bool _keyboardVisible = false;

  @override
  void initState() {

    resetRequestModel = new ResetRequestModel();
    confirmpassRequestModel = new ConfirmpassRequestModel();
    super.initState();
    setState(() {
      _pagestate = 0;
    });

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
          print("Keyboard State Changed : $visible");
        }
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup2(context),
      inAsyncCall: isApiCallProcess_reset || isApiCallProcess_confirmpass,
      opacity: 0.3,
    );
  }
  Widget _uiSetup2(BuildContext context) {
    //gets window size of emulator
    winheight = MediaQuery.of(context).size.height;
    winwidth = MediaQuery.of(context).size.width;
    _fpass_height = winheight - 270;
    reset_height = winheight - 270;



    switch(_pagestate)
    {
      case 0:

        _bgcolor = Color(0xFFff8a14);
        _headingcolor = Colors.white;
        _fpass_yoffset = 220;
        reset_yoffset = winheight;
        _fpass_xoffset = 0;
        _fpass_width = winwidth;
        _fpass_container_opacity = 1;
        _headingtop = 45;
        _fpass_height = _keyboardVisible ? winheight: winheight - 220;
        break;


      case 1:
        _bgcolor = Color(0xFFff8a14);
        _headingcolor = Colors.white;
        _fpass_yoffset = 200;

        reset_yoffset = 220;
        _fpass_xoffset = 20;
        _fpass_width = winwidth - 40;
        _fpass_container_opacity = 0.7;
        _headingtop = 40;
        _fpass_height = _keyboardVisible ? winheight: winheight - 150;
        reset_height = _keyboardVisible ? winheight: winheight - 170;
        break;


    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(

        children: [
          //Welcome background
          AnimatedContainer(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(
                seconds: 1,
              ),
              color: _bgcolor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children:<Widget> [
                  Container(

                      child:Column(
                        children: <Widget>[

                          AnimatedContainer(
                              curve: Curves.fastLinearToSlowEaseIn,
                              duration: Duration(
                                seconds: 1,
                              ),
                              margin:EdgeInsets.only(top:_headingtop) ,

                              child: Text(''
                                  'GradeEasy',

                                style: TextStyle(
                                  fontSize: 38,
                                  color: _headingcolor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                          ),

                          Container(
                              margin: EdgeInsets.all(25),

                              child: Center(
                                child: Text(
                                  'The one and only Destination of easily grading your papers ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: _headingcolor,

                                  ),
                                ),
                              )

                          )

                        ],
                      )
                  ),



                ],
              )

          ),

          //forgot password
          AnimatedContainer(
            width: _fpass_width,
            height: _fpass_height,
            padding: EdgeInsets.all(20),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
              seconds: 1,
            ),

            transform: Matrix4.translationValues(_fpass_xoffset,_fpass_yoffset,1),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(_fpass_container_opacity),
                borderRadius: BorderRadius.only(
                    topLeft:Radius.circular(35),
                    topRight: Radius.circular(35)
                )
            ),
            child: Form(
              key: globalFormKey_reset,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 15,bottom: 15),
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Dosis-Medium',

                          ),
                        ),
                      ),


                      SizedBox(height: 12,),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black54,
                                width: 2
                            ),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 60,
                              child: Icon(Icons.email,
                                  size: 25,
                                  color: Color(0xFFBB9B9B9)),

                            ),

                            Expanded(
                              child: TextFormField(
                                onSaved: (input) => resetRequestModel.email = input,

                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),

                                    border: InputBorder.none,
                                    hintText: 'Enter Your email'
                                ),
                                validator: (input) => !input.contains('@')
                                    ? "Email Id should be valid"
                                    : null,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          if (validateAndSave_reset()) {
                            print(resetRequestModel.toJson());

                            setState(() {
                              isApiCallProcess_reset = true;
                            });

                            Reset_APIService apiService_reset= new Reset_APIService();
                            apiService_reset.reset(resetRequestModel).then((value) {
                              if (value != null) {
                                setState(() {
                                  isApiCallProcess_reset = false;
                                });

                                if (value.token.isNotEmpty) {
                                  reset_token = value.token;
                                  // print(reset_token);
                                  final snackBar = SnackBar(
                                      content: Text('Success')
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  setState(() {
                                    _pagestate = 1;
                                  },

                                  );


                                } else {
                                  final snackBar =
                                  SnackBar(content: Text('Data incorrect.Please Try again'));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  globalFormKey_reset.currentState.reset();


                                }
                              }
                            }
                            );
                          }
                        },

                        child: PrimaryButton(

                          btnText: "Proceed",
                        ),
                      ),
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pagestate = 1;
                          });
                        },
                        child: OutlineBtn(
                          btnText: "Already have Account -Login",
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

          ),

          // Reset password
          AnimatedContainer(
            height: reset_height,
            padding: EdgeInsets.all(20),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
              seconds: 1,
            ),

            transform: Matrix4.translationValues(0,reset_yoffset,1),

            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft:Radius.circular(35),
                    topRight: Radius.circular(35)
                )
            ),
            child: Form(
              key: globalFormKey_confirmpass,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Dosis-Medium',

                          ),
                        ),
                      ),


                      SizedBox(height: 12,),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.purpleAccent,
                                width: 2
                            ),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 60,
                              child: Icon(Icons.vpn_key,
                                  size: 25,
                                  color: Color(0xFFBB9B9B9)),

                            ),

                            Expanded(
                              child: TextFormField(
                                controller: confirm_pass,
                                obscureText: true,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),

                                    border: InputBorder.none,
                                    hintText: 'Enter Your Password'
                                ),
                                onSaved: (input) => confirmpassRequestModel.password = input,
                                validator: (input) => input.length < 6
                                    ? "Password should be more than 6 characters"
                                    : null,

                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 12,),

                      GestureDetector(
                        onTap: () {
                          if (validateAndSave_confirmpass()) {
                            print(confirmpassRequestModel.toJson());

                            setState(() {
                              isApiCallProcess_confirmpass = true;
                            });

                            ConfirmPass_APIService apiService_confirmpass= new ConfirmPass_APIService();
                            apiService_confirmpass.confirmpass(confirmpassRequestModel).then((value) {
                              if (value != null) {
                                setState(() {
                                  isApiCallProcess_confirmpass = false;
                                });

                                if (value.status == 'ok') {
                                  final snackBar = SnackBar(
                                      content: Text('Reset Successful ')
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  setState(() {
                                    Navigator.pushNamed(context, '/login');
                                  },

                                  );


                                } else {
                                  final snackBar = SnackBar(
                                      content: Text(value.error)
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  globalFormKey_reset.currentState.reset();


                                }
                              }
                            }
                            );
                          }
                        },

                        child: PrimaryButton(

                          btnText: "Reset Password",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

      ),


        ],
      )
      ,
    );
  }

  bool validateAndSave_reset() {
    final form = globalFormKey_reset.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool validateAndSave_confirmpass() {
    final form = globalFormKey_confirmpass.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

}


//Container button for create account
class PrimaryButton extends StatefulWidget {
  final String btnText;
  PrimaryButton({this.btnText});

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFff8a14),
          borderRadius: BorderRadius.circular(50)
      ),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,

          ),
        ),
      ),
    );
  }
}

