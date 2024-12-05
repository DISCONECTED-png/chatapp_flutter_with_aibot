import 'package:chatappbuild/auth/loginpage.dart';
import 'package:chatappbuild/auth/registerpage.dart';
import 'package:flutter/material.dart';

class loginorregister extends StatefulWidget {
  const loginorregister({super.key});

  @override
  State<loginorregister> createState() => _loginorregisterState();
}

class _loginorregisterState extends State<loginorregister> {
  bool showloginpage=true;
  void togglepage(){
    setState(() {
      showloginpage=!showloginpage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showloginpage){
      return loginpage(
        onTap: togglepage,
      );
    }
    else{
      return registerpage(
        onTap: togglepage,
      );
    }
  }
}