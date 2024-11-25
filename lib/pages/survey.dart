import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  bool isboy = false;
  bool isgirl = false;
  bool isSelected = false;

  void onSelectMale() {
    setState(() {
      isboy = !isboy;
      isgirl = false;
    });
    debugPrint('Option Male selected.');
  }

  void onSelectFemale() {
    setState(() {
      isgirl = !isgirl;
      isboy = false;
    });
    debugPrint('Option Female selected.');
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey'),
        centerTitle: true,
      ),
      body: Container(
        width: screen.width,
        height: screen.height,
        child: Center(
          child: Container(
            height: screen.height * 0.4,
            width: screen.width * 0.9,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Question 1',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'What is your Gender?',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  '(Please choose from the options below) ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (isboy == true)
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/tick.png'))),
                            ),
                          GestureDetector(
                            onTap: onSelectMale,
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 50,
                              child: Center(
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(80),
                                      image: const DecorationImage(
                                          image: AssetImage('assets/boy1.jpg'),
                                          fit: BoxFit.contain)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (isgirl == true)
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/tick.png'))),
                            ),
                          GestureDetector(
                            onTap: onSelectFemale,
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 50,
                              child: Center(
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(80),
                                      image: const DecorationImage(
                                          image: AssetImage('assets/girl.jpg'),
                                          fit: BoxFit.contain)),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
