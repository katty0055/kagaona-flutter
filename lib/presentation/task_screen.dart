import 'package:flutter/material.dart';
import '../constants.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TITLE_APPBAR)),
      body: Center(child: Text(EMPTY_LIST)),
    );
  }
}

