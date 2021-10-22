
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeeasy2/main.dart';

import 'package:http/http.dart' as http;



import 'ProjectHUD.dart';

class Upload_Sample extends StatefulWidget {
  @override
  _Upload_SampleState createState() => _Upload_SampleState();
}

class _Upload_SampleState extends State<Upload_Sample> {
  bool isApiCallProcess_logout = false;
  LogoutRequestModel logoutRequestModel;

  double upload_button= 1,continue_button = 0;

  Future<int> uploadsample(fileurl) async {
    String url = "http://10.0.2.2:8000/grading/upload_sample/";
    var request = http.MultipartRequest('POST', Uri.parse(url))
    ..files.add(await http.MultipartFile.fromPath('file', fileurl,contentType: MediaType('pdf','docx')));

    request.send().then((response) {
      if (response.statusCode == 200)
        return ('Successs');
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
      child: _upload1Setup(context),
      inAsyncCall: isApiCallProcess_logout ,
      opacity: 0.3,
    );
  }

  @override
  Widget _upload1Setup(BuildContext context) {
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
                'Upload Sample Answersheet',
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


                  File file = await FilePicker.getFile(
                    type: FileType.custom,
                    allowedExtensions: [
                      'pdf'
                    ], //here you can add any of extention what you need to pick
                  );

                  var res = await uploadsample(file.path);


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
                    SnackBar(content: Text('Data incorrect.Please Try again'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  }

                 },

                child: PrimaryButton(
                  btnText: 'Upload',
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
