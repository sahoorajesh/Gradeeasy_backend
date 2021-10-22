import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gradeeasy2/Register/Register_model.dart';
import 'package:gradeeasy2/Upload-1.dart';
import 'package:gradeeasy2/Upload-2.dart';
import 'package:gradeeasy2/page2.dart';
import 'package:gradeeasy2/startgrading.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:quick_feedback/quick_feedback.dart';
import 'Download.dart';
import 'ProjectHUD.dart';
import 'Register/Register_api_service.dart';
import 'api_service.dart';
import 'login_model.dart';



String name = '', login_token, pass = '';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Dosis-ExtraBold'
      ),
      debugShowCheckedModeBanner: false,

      routes:
      {
        '/login': (context) => LoginPage(),
        '/forgotpass': (context) => stack2(),
        '/mainpage': (context) => Mainpage(),
        '/start_grading':(context)=>Start_grading(),
        '/sample':(context)=>Upload_Sample(),
        '/student': (context) => Upload_Student(),
        '/download':(context) => Download(),
        '/menu': (context) =>NavDrawer(),
      },
      home: Scaffold(
        resizeToAvoidBottomInset: false,

        body: LoginPage(),

      ),
    );
  }
}

class LoginPage  extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage > {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  bool isApiCallProcess_register = false;
  int _pagestate = 0;
  GlobalKey<FormState> globalFormKey_login = GlobalKey<FormState>();
  GlobalKey<FormState> globalFormKey_register = GlobalKey<FormState>();

  LoginRequestModel loginRequestModel;
  RegisterRequestModel registerRequestModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var myController = TextEditingController();
  var new_pass = TextEditingController();
  var con_pass = TextEditingController();
  var email = TextEditingController();
  var _bgcolor = Colors.white;
  var _headingcolor = Colors.white;

  double __xoffset_Login_Page = 0;
  double _yoffset_Login_Page = 0;
  double _yoffset_register_page = 0;
  double _register_height = 0;

  double Welcome_yoffset = 0;
  double feedback_height = 0,Homepage_height = 0;
  double feedback_yoffset = 0;

  double windowwidth = 0;
  double windowheight = 0;

  double _login_width = 0;
  double _loginHeight = 0;
  double _login_container_opacity = 1;

  double _headingtop = 75;
  bool _keyboardVisible = false;
  @override
  void initState() {
    loginRequestModel = new LoginRequestModel();
    registerRequestModel = new RegisterRequestModel();
    super.initState();

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
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess || isApiCallProcess_register,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {

    //gets window size of emulator
    windowheight = MediaQuery.of(context).size.height;
    windowwidth = MediaQuery.of(context).size.width;

    _loginHeight = windowheight - 270;
    _register_height = windowheight - 270;

    switch(_pagestate){
    //Welcome Page
      case 0:
        _bgcolor = Colors.white;
        _headingcolor = Color(0XFFB40284A);
        Welcome_yoffset = 0;
        _yoffset_Login_Page = windowheight;
        _yoffset_register_page = windowheight;

        __xoffset_Login_Page = 0;
        _login_width = windowwidth;

        _login_container_opacity = 1;
        _headingtop = 55;
        _loginHeight = _keyboardVisible ? windowheight : windowheight - 220;
        break;

    //Login Page
      case 1:
        _bgcolor = Color(0xFFff8a14);
        _headingcolor = Colors.white;
        _yoffset_Login_Page = 220;
        _yoffset_register_page = windowheight;

        __xoffset_Login_Page = 0;
        _login_width = windowwidth;
        _login_container_opacity = 1;
        _headingtop = 45;
        _loginHeight = _keyboardVisible ? windowheight: windowheight - 220;
        Welcome_yoffset = 0;
        break;

    //Register page 1
      case 2:
        _bgcolor = Color(0xFFff8a14);
        _headingcolor = Colors.white;
        _login_width = windowwidth - 40;
        _yoffset_Login_Page = 110;
        _yoffset_register_page = 130;

        __xoffset_Login_Page = 20;
        _login_container_opacity = 0.7;
        _headingtop = 40;
        _loginHeight = _keyboardVisible ? windowheight: windowheight - 110;
        _register_height = _keyboardVisible? windowheight: windowheight - 130;
        Welcome_yoffset = 0;

        break;


    }

    return Scaffold(

      body: Stack(

        children: [
          //Welcome Page
          AnimatedContainer(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(
                seconds: 1,
              ),
              transform: Matrix4.translationValues(0,Welcome_yoffset,1),
              color: _bgcolor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children:<Widget> [
                  GestureDetector(
                    onTap:() {
                      setState(() {
                        _pagestate = 0;
                      });
                    },
                    child: Container(

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
                  ),

                  Container(
                    child:Center(
                      child: Image.asset('assets/Gradeeasy.png',),
                    ),
                  ),

                  Container(
                      padding: EdgeInsets.all(20),
                      child:GestureDetector(
                        onTap: (){
                          setState(() {

                            if(_pagestate != 0){
                              _pagestate = 0;
                            }

                            else{
                              _pagestate = 1;
                            }
                          }
                          );
                        },
                        child: Container(
                            padding: EdgeInsets.all(20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Color(0xFFff8a14),
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child:
                            Center(
                              child: Text(
                                'Lets Get Started!!',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ),
                      )
                  ),
                ],
              )

          ),

          //Login Page
          AnimatedContainer(
            padding: EdgeInsets.all(30),
            width: _login_width,
            height: _loginHeight,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
              seconds: 1,
            ),

            transform: Matrix4.translationValues(__xoffset_Login_Page,_yoffset_Login_Page,1),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(_login_container_opacity),
                borderRadius: BorderRadius.only(
                    topLeft:Radius.circular(15),
                    topRight: Radius.circular(15)
                )
            ),

            child: Form(
              key: globalFormKey_login,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Login To Continue",
                          style: TextStyle(
                              fontSize: 25
                          ),
                        ),
                      ),

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
                              child: Icon(Icons.verified_user,
                                  size: 25,
                                  color: Color(0xFFBB9B9B9)),

                            ),

                            Expanded(
                              child: TextFormField(
                                onSaved: (input) => loginRequestModel.username = input,

                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),

                                    border: InputBorder.none,
                                    hintText: 'Enter Your Username'
                                ),
                                validator: (input) => input.length < 6
                                    ? "Username should be more than 6 characters"
                                    : null,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),

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
                                controller: con_pass,
                                obscureText: true,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),

                                    border: InputBorder.none,
                                    hintText: 'Enter Your Password'
                                ),
                                onSaved: (input) => loginRequestModel.password = input,
                                validator: (input) => input.length < 6
                                ? "Password should be more than 6 characters"
                                    : null,

                              ),
                            )
                          ],
                        ),
                      ),


                      SizedBox(height: 10,),
                      InkWell(

                          onTap: (){
                            Navigator.pushNamed(context, '/forgotpass');

                          },
                          child: Align(

                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot Password?   ',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontStyle: FontStyle.italic
                                ),

                              )
                          )
                      )
                    ],
                  ),
                  Column(

                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (validateAndSave_login()) {
                            print(loginRequestModel.toJson());

                            setState(() {
                              isApiCallProcess = true;
                            });

                            APIService apiService = new APIService();
                            apiService.login(loginRequestModel).then((value) {
                              if (value != null) {
                                setState(() {
                                  isApiCallProcess = false;
                                });

                                if (value.token.isNotEmpty) {
                                  name = loginRequestModel.username;
                                  pass = loginRequestModel.password;
                                  login_token = value.token;
                                  final snackBar = SnackBar(
                                      content: Text('Login Success!!! Welcome ' + loginRequestModel.username)
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  Navigator.pushNamed(context, '/mainpage');
                                } else {
                                  final snackBar =
                                  SnackBar(content: Text('Credentials provided are incorrect.Please Try again'));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                }
                              }
                            });
                          }
                        },
                        child: PrimaryButton(
                          btnText: "Login",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pagestate = 2;
                          });
                        },
                        child: OutlineBtn(
                          btnText: "Create New Account",
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),


          //Register Page
          AnimatedContainer(
            height: _register_height,
            padding: EdgeInsets.all(20),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
              seconds: 1,
            ),

            transform: Matrix4.translationValues(0,_yoffset_register_page,1),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft:Radius.circular(35),
                    topRight: Radius.circular(35)
                )
            ),
            child: Form(
              key: globalFormKey_register,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(

                    children: <Widget>[
                      Container(

                        margin: EdgeInsets.only(top:5,bottom: 10),
                        child: Text(
                          "Create a New Account",
                          style: TextStyle(
                            fontSize: 30,

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
                              child: Icon(Icons.people,
                                  size: 25,
                                  color: Color(0xFFBB9B9B9)),

                            ),

                            Expanded(
                              child: TextFormField(
                                onSaved: (input) => registerRequestModel.username = input,

                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),

                                    border: InputBorder.none,
                                    hintText: 'Enter Your Username'
                                ),
                                validator: (input) => input.length < 5
                                    ? "Username should be more than 5 characters"
                                    : null,
                              ),
                            )
                          ],
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
                                onSaved: (input) => registerRequestModel.email = input,

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
                                controller: new_pass,
                                obscureText: true,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),

                                    border: InputBorder.none,
                                    hintText: 'Enter Your Password'
                                ),
                                onSaved: (input) => registerRequestModel.password = input,
                                validator: (input) => input.length < 6
                                    ? "Password should be more than 6 characters"
                                    : null,

                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 22,),

                    ],
                  ),
                  Column(
                    children: <Widget>[
                      GestureDetector(

                        onTap: () {
                          if (validateAndSave_register()) {
                            print(registerRequestModel.toJson());

                            setState(() {
                              isApiCallProcess_register = true;
                            });

                            Register_APIService apiService_register = new Register_APIService();
                            apiService_register.register(registerRequestModel).then((value) {
                              if (value != null) {
                                setState(() {
                                  isApiCallProcess_register = false;
                                });

                                if (value.token.isNotEmpty) {
                                  final snackBar = SnackBar(
                                      content: Text('Register Successful!!! ')
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  setState(() {
                                    _pagestate = 1;
                                  },

                                  );
                                  con_pass.text = '';

                                } else {
                                  final snackBar =
                                  SnackBar(content: Text('Data incorrect.Please Try again'));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  globalFormKey_register.currentState.reset();

                                  new_pass.text = '';
                                }
                              }
                            }
                            );
                          }
                        },

                        child: PrimaryButton(

                          btnText: "Register",

                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
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

        ],



      )
    );

  }

  bool validateAndSave_login() {
    final form = globalFormKey_login.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool validateAndSave_register() {
    final form = globalFormKey_register.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }


}
//Main Page
class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  bool isApiCallProcess_logout = false;
  LogoutRequestModel logoutRequestModel;

  @override
  void initState() {
    logoutRequestModel = new LogoutRequestModel();

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _mainpageSetup(context),
      inAsyncCall: isApiCallProcess_logout,
      opacity: 0.3,
    );
  }

  Widget _mainpageSetup(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text('GradeEasy',
            style:
            TextStyle(
                fontSize: 30,
                fontFamily: 'Dosis-BoldItalic'
            ),),
          centerTitle: true,

          backgroundColor: Color(0xFFff8a14),
          actions: [
            GestureDetector(
              onTap: () {

                  setState(() {
                    isApiCallProcess_logout = true;
                  });

                  Logout_APIService apiService = new Logout_APIService();
                  apiService.logout(logoutRequestModel).then((value) {
                    if (value != null) {
                      print(logoutRequestModel.toJson());
                      setState(() {
                        isApiCallProcess_logout  = false;
                      });

                      if (value.status.isNotEmpty) {
                        final snackBar = SnackBar(
                            content: Text('Logged out Successfully ')
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {
                          Navigator.pushNamed(context, '/login');
                        },

                        );


                      }
                    }
                  }
                  );

              },
              child: Icon(Icons.logout,color: Colors.white,size: 30,),

            ),

          ],


        ),
        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/start_grading');
                },
                child: Center(child: Image(image: AssetImage('assets/Grading.png'),height: 220,width: 220,))),
            Center(
              child: Text('Grading',
                style: TextStyle(
                    color: Colors.red[800],
                    fontSize: 35,fontWeight: FontWeight.bold
                ),
              ),
            ),
            Center(
              child: Text('Start Grading Your Assignments',
                style: TextStyle(
                    color: Colors.red[800],
                    fontSize: 25,fontStyle: FontStyle.italic
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                _showFeedback(context);
              },
              child: Center(
                  child: Image(
                    image: AssetImage('assets/Feedback.png'),height: 220,width: 220,
                  )
              ),
            ),
            Center(
              child: Text('Feedback',
                style: TextStyle(
                    color: Colors.red[800],
                    fontSize: 35,fontWeight: FontWeight.bold
                ),
              ),
            ),
            Center(
              child: Text('Help us to improve',
                style: TextStyle(
                    color: Colors.red[800],
                    fontSize: 25,fontStyle: FontStyle.italic
                ),
              ),
            ),

          ],
        )
    );
  }
}
class LogoutResponseModel {
  final String status;
  final String error;

  LogoutResponseModel({this.status,this.error});

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) {
    return LogoutResponseModel(
      status: json["status"] != null ? json["status"] : "ok",
      error: json["error"] != null ? json["error"] : "",
    );
  }
}

class LogoutRequestModel {

  String username;
  String password;

  LogoutRequestModel({
    this.username,
    this.password

    });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {

      'username': name,
      'password': pass,

    };

    return map;
  }
}



// ignore: camel_case_types
class Logout_APIService {
  Future<LogoutResponseModel> logout(LogoutRequestModel requestModel) async {
    String url = "http://10.0.2.2:8000/api/logout/";

    final response = await http.post(url,headers: {'Authorization': 'token ' + login_token }, body: requestModel.toJson());
    if (response.statusCode == 200) {
      return LogoutResponseModel.fromJson(
        json.decode(response.body.toString()),
      );
    }
  }
}


//feedback
void _showFeedback(context) {
  showDialog(

    context: context,
    builder: (context) {
      return QuickFeedback(
        title: 'Leave a feedback', // Title of dialog
        showTextBox: true, // default false
        textBoxHint:
        'Share your feedback', // Feedback text field hint text default: Tell us more
        submitText: 'SUBMIT', // submit button text default: SUBMIT
        onSubmitCallback: (feedback) {
          print('$feedback'); // map { rating: 2, feedback: 'some feedback' }
          Navigator.of(context).pop();
        },
        askLaterText: 'ASK LATER',
        onAskLaterCallback: () {
          print('Do something on ask later click');
        },
      );
    },
  );
}

class InputWithIcon extends StatefulWidget {
  final IconData icon;
  final String hint;
  bool obscure_Text;

  InputWithIcon({this.icon, this.hint,this.obscure_Text});


  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  var tc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Icon(
                widget.icon,
                size: 25,
                color: Color(0xFFBB9B9B9),
              )
          ),
          Expanded(
            child: TextField(

              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),

                  border: InputBorder.none,
                  hintText: widget.hint
              ),
              controller: tc,
              obscureText: widget.obscure_Text,

            ),
          )
        ],
      ),
    );
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

//container button for back to login button
class OutlineBtn extends StatefulWidget {
  final String btnText;
  OutlineBtn({this.btnText});

  @override
  _OutlineBtnState createState() => _OutlineBtnState();
}


class _OutlineBtnState extends State<OutlineBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black54,
              width: 2
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      padding: EdgeInsets.all(15),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(
            color: Color(0xFFB40284A),
            fontSize:20 ,
            fontFamily: 'Dosis-ExtraBold',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(

        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(

            decoration: BoxDecoration(
                // color: Colors.blue[400],
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))), child: null,
          ),

          ListTile(
            title: Text('Welcome, '+ name ,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),),
            onTap: () => {},
          ),

        ],
      ),
    );
  }
}
