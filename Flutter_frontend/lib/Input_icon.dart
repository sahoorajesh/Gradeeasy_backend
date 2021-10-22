import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputWithIcon extends StatefulWidget {
  final IconData icon;
  final String hint;
  bool obscure_Text;

  TextEditingController tc = new TextEditingController();
  InputWithIcon({this.icon, this.hint,this.obscure_Text,this.tc});


  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
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
              //controller: myController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),

                  border: InputBorder.none,
                  hintText: widget.hint
              ),
              controller: widget.tc,
              obscureText: widget.obscure_Text,

            ),
          )
        ],
      ),
    );
  }

}