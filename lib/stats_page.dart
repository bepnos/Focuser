import 'package:provider/provider.dart';
import 'package:focuser/study_data.dart';

import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var studyData = Provider.of<StudyData>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Stats"),
          Text("Daily: ${studyData.getTimeDaily()}"),
          Text("Weekly: ${studyData.getTimeWeekly()}"),
          Text("All-time: ${studyData.getTimeAll()}"),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              studyData.deleteStats();
            },
            child: const Text("Reset"),
          ),
          ElevatedButton(
              onPressed: () {
                studyData.testMethod();
              },
              child: const Text("Test")),
          ElevatedButton(
              onPressed: () {
                studyData.testMethod2();
              },
              child: const Text("Test2"))
        ],
      ),
    );
  }
}
