import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
            width: screen.width,
            height: screen.height,
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screen.width * 0.3,
                          height: screen.height * 0.2,
                          decoration: BoxDecoration(color: Colors.blue),
                        ),
                        Container(
                          width: screen.width * 0.3,
                          height: screen.height * 0.2,
                          decoration: BoxDecoration(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Text('You have 13 Task\'s left to complete '),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
