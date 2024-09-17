import 'package:flutter/material.dart';
import 'package:homeasz/components/dropdown.dart';

class MiniDropdown extends StatelessWidget{
  const MiniDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Dropdown(fontSize: 15,hint:"Set state",title: "Action" );
  }
}