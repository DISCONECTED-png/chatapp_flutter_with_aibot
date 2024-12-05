import 'package:flutter/material.dart';

class mybutton extends StatelessWidget {
  final void Function()? ontap;
  final String text;
  const mybutton({super.key,required this.ontap,required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.tertiary,borderRadius: BorderRadius.circular(50)),
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 100),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
      ),
    );
  }
}
