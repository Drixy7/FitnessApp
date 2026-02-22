import 'dart:async';

import 'package:flutter/material.dart';

//todo implement stop/start buttons
class WorkoutTimer extends StatefulWidget {
  final int initialSeconds;
  final Future<void> Function(int) onSave;
  final void Function(int) onTick;
  const WorkoutTimer({
    super.key,
    required this.initialSeconds,
    required this.onSave,
    required this.onTick,
  });

  @override
  State<WorkoutTimer> createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer>
    with WidgetsBindingObserver {
  late int _currentSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentSeconds = widget.initialSeconds;
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  // Tato metoda se zavolá VŽDY, když uživatel minimalizuje aplikaci nebo se do ní vrátí
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _stopTimer();
      widget.onSave(_currentSeconds);
    } else if (state == AppLifecycleState.resumed) {
      _startTimer();
    }
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentSeconds++;
        });
        widget.onTick(_currentSeconds);
      }
    });
  }

  @override
  void dispose() {
    widget.onSave(_currentSeconds);
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String _formatTime(int timeInSeconds) {
    final d = Duration(seconds: timeInSeconds);
    String fmt(int n) => n.toString().padLeft(2, '0');

    return "${fmt(d.inHours)}:${fmt(d.inMinutes.remainder(60))}:${fmt(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(_currentSeconds),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFeatures: [
          const FontFeature.tabularFigures(),
        ], // Keeps numbers from jumping width
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
