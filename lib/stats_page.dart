import 'package:provider/provider.dart';
import 'package:focuser/study_data.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var studyData = Provider.of<StudyData>(context);
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Time: ${studyData.getTime()}"),
                ),
                // space that takes up the rest of the space
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownMenu(
                    dropdownMenuEntries: studyData.getDropdownMenuEntries(),
                    onSelected: (index) {
                      studyData.dropdownChanged(index);
                    },
                    initialSelection: 0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SfCartesianChart(
              plotAreaBorderWidth: 0,
              title: ChartTitle(
                text: "${studyData.getTimeWeekly()}",
              ),
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  labelFormat: '{value}',
                  majorTickLines: const MajorTickLines(size: 0)),
              series: studyData.getWeeklySeries(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      studyData.deleteStats();
                    },
                    child: const Text("Reset"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        studyData.testMethod();
                      },
                      child: const Text("Test")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        studyData.testMethod2();
                      },
                      child: const Text("Test2")),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
