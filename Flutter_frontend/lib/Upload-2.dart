import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeeasy2/main.dart';

import 'package:http/http.dart' as http;
import 'ProjectHUD.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
class Upload_Student extends StatefulWidget {
  @override
  _Upload_StudentState createState() => _Upload_StudentState();
}

class _Upload_StudentState extends State<Upload_Student> {
  bool isApiCallProcess_logout = false;
  LogoutRequestModel logoutRequestModel;
  double upload_button= 1,continue_button = 0;



  Future<int> uploadstudent(fileurl) async {
    String url = "http://10.0.2.2:8000/grading/upload_student/";
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..files.add(await http.MultipartFile.fromPath('file1', fileurl,contentType: MediaType('pdf','docx')));

    request.send().then((response) {
      if (response.statusCode == 200)
        return (response.statusCode);
      else
        return (response.statusCode);
    });
  }
  @override
  void initState() {
    logoutRequestModel = new LogoutRequestModel();
    upload_button = 1;
    continue_button = 0;

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _upload2Setup(context),
      inAsyncCall: isApiCallProcess_logout,
      opacity: 0.3,
    );
  }
  @override
  Widget _upload2Setup(BuildContext context) {
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
      body: Column(

          children:[
            SizedBox(height: 10,),
            Text(
              "Upload",
              style: TextStyle(
                fontSize: 25,
              ),
            ),

            Container(
              child: Image(image: AssetImage('assets/upload_icon.png'),height: 180,width: 180,),
            ),

            Opacity(
              opacity: upload_button,
              child: GestureDetector(
                onTap:() async{


                  File file_stu = await FilePicker.getFile(
                    type: FileType.custom,
                    allowedExtensions: [
                      'pdf'
                    ], //here you can add any of extention what you need to pick
                  );

                  var res = await uploadstudent(file_stu.path);


                  if(res != 'null')
                  {
                    setState(() {
                      continue_button = 1;
                      upload_button = 0;
                    });
                    final snackBar = SnackBar(
                        content: Text('Uploaded successfully ')
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  }
                  else {
                    final snackBar =
                    SnackBar(content: Text('Internal Server Error!Try again after some time'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  }

                },

                child: PrimaryButton(
                  btnText: 'Upload Students Answersheet',
                ),
              ),
            ),
            SizedBox(height: 20,),
            Opacity(
              opacity: continue_button,
              child: Column(
                children: [
                  PrimaryButton(
                    btnText: 'Uploaded Successfully ',

                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                    Navigator.pushNamed(context, '/start_grading');
                  },
                    child: PrimaryButton(
                    btnText: 'Continue ',

                  ),

                ),

              ]
              ),
            )

          ]
      ),

    );
  }
}
