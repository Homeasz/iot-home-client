import 'package:flutter/material.dart';
import 'package:homeasz/components/modal_sheets/dropdown.dart';

class MiniDropdown extends StatelessWidget{
  const MiniDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dropdown(fontSize: 15,hint:"Set state",title: "Action" );
  }
}