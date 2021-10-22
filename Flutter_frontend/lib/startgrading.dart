import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ProjectHUD.dart';
import 'main.dart';

class Start_grading extends StatefulWidget {
  @override
  _Start_gradingState createState() => _Start_gradingState();
}

class _Start_gradingState extends State<Start_grading> {bool isApiCallProcess_logout = false;
LogoutRequestModel logoutRequestModel;

@override
void initState() {
  logoutRequestModel = new LogoutRequestModel();

  super.initState();

}

@override
Widget build(BuildContext context) {
  return ProgressHUD(
    child: _gradingSetup(context),
    inAsyncCall: isApiCallProcess_logout,
    opacity: 0.3,
  );
}

@override
Widget _gradingSetup(BuildContext context) {
    return  Scaffold(

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

        children: [
          SizedBox(height: 10,),
          Row(
            children: [
              GestureDetector(
                onTap: (){
                      Navigator.pushNamed(context, '/sample');
                },
                child: Image(image: AssetImage('assets/Upload.png'),height: 180,width: 180,),
              ),
              SizedBox(width: 40,),
              Column(
                  children:[
                    Text('Upload ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text('Sample ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text('Answersheet ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ]
              ),
            ],
          ),
          Row(
            children:[
              SizedBox(width: 20,),
              Column(
                  children:[
                    Text('Upload ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text('Students ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text('Answersheet ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ]
              ),
              SizedBox(width: 40,),
              GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/student');
                  },
                  child: Image(image: AssetImage('assets/Boy.webp'),height:175,width:175)),

            ],
          ),
          Row(
            children: [
              GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/download');
                  },
                  child: Image(image: AssetImage('assets/Download.png'),height: 180,width: 180,)),
              SizedBox(width: 40,),
              Column(
                  children:[
                    Text('View Your ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Center(
                      child: Text('Grades ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ]
              ),
            ],
          ),
        ],
      ),

    );

  }
}





