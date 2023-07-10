import 'package:flutter/material.dart';

class AddDaily extends StatefulWidget {
  const AddDaily({Key? key}) : super(key: key);

  @override
  State<AddDaily> createState() => _AddDailyState();
}

class _AddDailyState extends State<AddDaily> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('add employee'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: Text('add new daily'),
        )
    );
  }
}
