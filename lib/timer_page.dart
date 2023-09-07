import "package:flutter/material.dart";
import "package:focuser/study_data.dart";
import "package:provider/provider.dart";

class TimerPage extends StatelessWidget {
  const TimerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var studyData = Provider.of<StudyData>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            studyData.getStopwatch.isRunning ? "Focus!" : " ",
          ),
          _TimeWidget(stopwatch: studyData.getStopwatch),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    if (studyData.getStopwatch.isRunning) {
                      studyData.controlButtonPressed("pause");
                    } else {
                      studyData.controlButtonPressed("start");
                    }
                  },
                  child: Icon(studyData.getStopwatch.isRunning
                      ? Icons.pause
                      : Icons.play_arrow)),
              const SizedBox(width: 30.0),
              ElevatedButton(
                  onPressed: () {
                    studyData.controlButtonPressed("reset");
                  },
                  child: Icon(Icons.replay)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeWidget extends StatelessWidget {
  _TimeWidget({super.key, required this.stopwatch});

  final Stopwatch stopwatch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          determineTime(),
          style: style,
        ),
      ),
    );
  }

  String determineTime() {
    int minutes = stopwatch.elapsed.inMinutes;
    int seconds = stopwatch.elapsed.inSeconds % 60;

    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = seconds.toString().padLeft(2, '0');

    return "$minutesString:$secondsString";
  }
}
