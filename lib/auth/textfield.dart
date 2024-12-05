import 'package:flutter/material.dart';

class textfield extends StatelessWidget {
  final controller;
  final String hinttext;
  final bool obsecuretext;
  final FocusNode? focusnode;
  const textfield({super.key,required this.controller,required this.hinttext,required this.obsecuretext,this.focusnode});

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.symmetric(horizontal:25),
                child: TextField(
                  controller: controller,
                  obscureText: obsecuretext,
                  focusNode: focusnode,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),borderRadius: BorderRadius.circular(15)),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: hinttext,
                    hintStyle: TextStyle(color:Theme.of(context).colorScheme.inversePrimary),
                  ),
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                ),
              );
  }
}