import "package:flutter/material.dart";

class TimerPage extends StatelessWidget {
  final Stopwatch stopwatch;
  final Function(String action) onButtonPressed;
  const TimerPage({
    super.key,
    required this.stopwatch,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            stopwatch.isRunning ? "Focus!" : " ",
          ),
          _TimeWidget(stopwatch: stopwatch),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    if (stopwatch.isRunning) {
                      onButtonPressed("pause");
                    } else {
                      onButtonPressed("start");
                    }
                  },
                  child: Icon(
                      stopwatch.isRunning ? Icons.pause : Icons.play_arrow)),
              const SizedBox(width: 30.0),
              ElevatedButton(
                  onPressed: () {
                    onButtonPressed("reset");
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
