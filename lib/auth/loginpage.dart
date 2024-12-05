import 'package:chatappbuild/auth/authservice.dart';
import 'package:chatappbuild/auth/mybutton.dart';
import 'package:chatappbuild/auth/textfield.dart';
import 'package:flutter/material.dart';

class loginpage extends StatelessWidget {
  final usercontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final void Function()? onTap;
  loginpage({super.key, required this.onTap});
  void login(BuildContext context) async {
    final authsrvice = authservice();
    try {
      await authsrvice.signinwithemailandpassword(
        usercontroller.text,
        passwordcontroller.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.tertiary
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight)),
        child: SafeArea(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 5),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Icon(
                      Icons.chat,
                      size: 100,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Welcome back, you've been missed",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary),
                          textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    textfield(
                      controller: usercontroller,
                      hinttext: "Username",
                      obsecuretext: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    textfield(
                      controller: passwordcontroller,
                      hinttext: "Password",
                      obsecuretext: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    mybutton(
                      ontap: () => login(context),
                      text: "Login",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a member?  ",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: onTap,
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondary,
                                fontSize: 15),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
