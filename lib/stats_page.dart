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
                    child: Text("Today: ${studyData.getTimeDaily()}")),
                // space that takes up the rest of the space
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownMenu(
                    dropdownMenuEntries: studyData.getDropdownMenuEntries(),
                    onSelected: (index) {
                      studyData.dropdownChanged(index);
                    },
                    initialSelection: studyData.currentSelected,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            StatsWidget(studyData: studyData),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Reset"),
                              content: const Text(
                                  "Are you sure you want to reset your data?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    studyData.deleteStats();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Reset"),
                                ),
                              ],
                            );
                          });
                    },
                    child: const Text("Reset"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: const Text("Manual"),
                                content: SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: 50,
                                      maxHeight: 100,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2019),
                                              lastDate: DateTime.now(),
                                            ).then((date) {
                                              if (date != null) {
                                                studyData.manualAdd(date);
                                                setState(() {});
                                              }
                                            });
                                          },
                                          child: Text(
                                              "${studyData.manualDate.day}/${studyData.manualDate.month}/${studyData.manualDate.year}"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 0, minute: 0),
                                              initialEntryMode:
                                                  TimePickerEntryMode.input,
                                              helpText: "Time spent studying",
                                            ).then((time) {
                                              if (time != null) {
                                                studyData.manualAddTime(time);
                                                setState(() {});
                                              }
                                            });
                                          },
                                          child: Text(
                                              "${studyData.manualTime.hour.toString().padLeft(2, "0")}:${studyData.manualTime.minute.toString().padLeft(2, "0")}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      studyData.manualAddComplete();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Add"),
                                  ),
                                ],
                              );
                            });
                          });
                    },
                    child: const Text("Manual"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatsWidget extends StatelessWidget {
  const StatsWidget({
    super.key,
    required this.studyData,
  });

  final StudyData studyData;

  @override
  Widget build(BuildContext context) {
    switch (studyData.currentSelected) {
      case 0:
        return Placeholder();
      case 1:
        return _buildWeeklyChart();
      case 2:
        return _buildMonthlyChart();
      default:
        return Placeholder();
    }
  }

  Widget _buildWeeklyChart() {
    return SfCartesianChart(
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
    );
  }

  Widget _buildMonthlyChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: "${studyData.getTimeMonthly()}",
      ),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0)),
      series: studyData.getMonthlySeries(),
    );
  }
}
