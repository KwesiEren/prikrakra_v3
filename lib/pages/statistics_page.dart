import 'package:flutter/material.dart';
import 'package:prikrakra_v3/services/supabase_config/sb_db.dart';
import 'package:prikrakra_v3/utils/shared_preferences_helper.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final dbConfig = SupaDB();
  String? catchUser;
  int userTasks = 0; // Changed to int
  int completedTasks = 0;
  int uncompletedTasks = 0;

  @override
  void initState() {
    _fetchTaskStatistics();
    super.initState();
  }

  Future<void> _fetchTaskStatistics() async {
    catchUser = SharedPreferencesHelper.getUsername() as String?;
    if (catchUser == null) return;

    try {
      final taskCount = await dbConfig.countTaskCreated(catchUser!);
      final completedCount =
          await dbConfig.countTasksByStatus(catchUser!, true);
      final uncompletedCount =
          await dbConfig.countTasksByStatus(catchUser!, false);

      setState(() {
        userTasks = taskCount;
        completedTasks = completedCount;
        uncompletedTasks = uncompletedCount;
      });
    } catch (e) {
      debugPrint('Error fetching task count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
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
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userTasks.toString(), // Convert to string
                            style: const TextStyle(
                                fontSize: 70, fontWeight: FontWeight.bold),
                          ),
                          const Text(
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
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            completedTasks.toString(), // Convert to string
                            style: const TextStyle(
                                fontSize: 70, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Tasks completed',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Text(
                  '$uncompletedTasks Tasks left to complete.', // Convert to string
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(127, 0, 0, 0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
