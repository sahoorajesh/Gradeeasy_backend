import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeeasy2/View_grade/Viewgrade_api.dart';
import 'package:gradeeasy2/main.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'ProjectHUD.dart';
import 'View_grade/Viewgrade_model.dart';


class Download extends StatefulWidget {
  @override
  _DownloadState createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  bool isApiCallProcess_logout = false;
  LogoutRequestModel logoutRequestModel;
  bool isApiCallProcess_download = false;
  ViewgradeRequestModel viewgradeRequestModel;
  double grade_opacity = 0,view_grade_opacity = 0;
  double Total_marks,Final_grade;
  bool _keyboardVisible = false;
  var user_input = TextEditingController();

  @override
  void initState() {
    logoutRequestModel = new LogoutRequestModel();
    viewgradeRequestModel = new ViewgradeRequestModel();
    grade_opacity = 0;
    view_grade_opacity = 0;

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
      child: _downloadSetup(context),
      inAsyncCall: isApiCallProcess_logout || isApiCallProcess_download,
      opacity: 0.3,
    );
  }

  @override
  Widget _downloadSetup(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          'GradeEasy',
          style:
          TextStyle(
            fontSize: 30,

          ),
        ),
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

          children:[
            SizedBox(height: 10,),

            Text(
              'View your Grades',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: Image(image: AssetImage('assets/Download_grade.png'),height: 90,width: 90,),
            ),
            SizedBox(height: 20,),
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
                    child: Icon(Icons.input,
                        size: 25,
                        color: Color(0xFFBB9B9B9)),

                  ),

                  Expanded(
                    child: TextFormField(
                      controller: user_input,

                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10),

                          border: InputBorder.none,
                          hintText: 'Enter total Marks for question:'
                      ),
                      validator: (input) => user_input.text.isNotEmpty
                          ? "Total Marks Cannot be Empty"
                          : null,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                setState(() {
                  Total_marks = double.parse(user_input.text);
                  view_grade_opacity = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFff8a14),
                    borderRadius: BorderRadius.circular(50)
                ),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),

            Opacity(
              opacity: view_grade_opacity,
              child: GestureDetector(
                onTap: () {

                  setState(() {
                    isApiCallProcess_download = true;
                  });

                  Viewgrade_APIService viewgrade = new Viewgrade_APIService();
                  viewgrade.viewgrade(viewgradeRequestModel).then((value) {
                    if (value != null) {

                      setState(() {
                        isApiCallProcess_download  = false;
                      });

                      if (value.Final_Grade.isNotEmpty) {
                        setState(() {
                          grade_opacity = 1;
                          Final_grade = Total_marks * double.parse(value.Final_Grade);
                        });

                      }
                    }
                  }
                  );

                },
                child: Container(
                  child: PrimaryButton(
                    btnText: 'Get Final Grades',
                  ),
                ),

              ),
            ),
            SizedBox(height: 20,),

            Opacity(
              opacity: grade_opacity,

              child: Column(

                  children: [

                    Container(
                        child: Text(

                            'Final Grades: ' + Final_grade.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25

                          ),
                        ),

                    ),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/start_grading');
                      },
                      child: PrimaryButton(
                        btnText: 'Back To Grading',
                      ),
                    ),

                    SizedBox(height: 20,),

                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/mainpage');
                      },
                      child: OutlineBtn(
                        btnText: 'Back to main menu',
                      ),
                    ),


                  ]
              ),
            ),


          ]
      ),

    );
  }
}

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
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(
            color: Color(0xFFB40284A),
            fontSize: 27 ,
            fontFamily: 'Dosis-ExtraBold',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

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
            fontSize: 24,
            fontWeight: FontWeight.bold,

          ),
        ),
      ),
    );
  }
}