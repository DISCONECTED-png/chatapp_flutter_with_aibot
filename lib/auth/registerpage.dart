import 'package:chatappbuild/auth/authservice.dart';
import 'package:chatappbuild/auth/mybutton.dart';
import 'package:chatappbuild/auth/textfield.dart';
import 'package:flutter/material.dart';

class registerpage extends StatelessWidget {
  final usercontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final cpwcontroller = TextEditingController();
  final void Function()? onTap;
  registerpage({super.key, required this.onTap});
  void register(BuildContext context) {
    final auth = authservice();
    if (passwordcontroller.text == cpwcontroller.text) {
      try {
        auth.signupwithemailandpassword(
            usercontroller.text, passwordcontroller.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    else{
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Passwords dont match"),
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
        end: Alignment.bottomRight)
        ),
        child: SafeArea(
          child: Center(
            child: ListView(
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
                    height: 40,
                  ),
                  Text(
                    "Let's get started",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary),
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
                    height: 10,
                  ),
                  textfield(
                      controller: cpwcontroller,
                      hinttext: "Confirm Password",
                      obsecuretext: true),
                    const SizedBox(
                      height: 20,
                    ),
                  mybutton(
                    ontap: () => register(context),
                    text: "Login",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member?  ",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: onTap,
                        child: Text(
                          "Login Now",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              ),],
            ),
          ),
        ),
      ),
    );
  }
}
