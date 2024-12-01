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
        title: const Text('Statistics'),
        // foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              // color: Colors.deepPurple,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screen.width * 0.4,
                    height: screen.height * 0.25,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(148, 19, 15, 15),
                            offset: Offset(4, 3),
                            blurRadius: 10,
                          )
                        ]),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '30',
                          style: TextStyle(
                              fontSize: 70, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Tasks created',
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: screen.width * 0.4,
                    height: screen.height * 0.25,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(148, 19, 15, 15),
                            offset: Offset(4, 3),
                            blurRadius: 10,
                          )
                        ]),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '17',
                          style: TextStyle(
                              fontSize: 70, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Tasks completed',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              // color: Colors.blue,
              child: const Text(
                '13 Tasks left to complete.',
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(127, 0, 0, 0)),
              ),
            )
          ],
        ),
      )),
    );
  }
}
