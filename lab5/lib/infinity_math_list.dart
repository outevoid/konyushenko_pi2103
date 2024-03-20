import 'package:flutter/material.dart';
import 'dart:math' as math;

class InfinityMathList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список элементов'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          int result = math.pow(2, index).toInt();
          return ListTile(
            title: Text('2 ^ $index = $result'),
          );
        },
      ),
    );
  }
}
