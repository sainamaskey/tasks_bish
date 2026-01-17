import 'package:flutter/material.dart';

class EmptyTaskWidget extends StatelessWidget {
  const EmptyTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('No tasks yet. Add one to start!'));
  }
}
