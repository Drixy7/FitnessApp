import 'dart:async';

import 'package:fitness_app/utils/formatters.dart';
import 'package:flutter/material.dart';

class WorkoutTimer extends StatefulWidget {
  final int initialSeconds;
  final bool startPaused;
  final Future<void> Function(int) onSave;
  final void Function(int) onTick;

  const WorkoutTimer({
    super.key,
    required this.initialSeconds,
    this.startPaused = false,
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
  DateTime? _lastTickTime;

  late bool _isRunning;

  @override
  void initState() {
    super.initState();
    _currentSeconds = widget.initialSeconds;
    _isRunning = !widget.startPaused;
    WidgetsBinding.instance.addObserver(this);

    if (_isRunning) {
      _lastTickTime = DateTime.now();
      _startTimer();
    }
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _lastTickTime = DateTime.now();
        _startTimer();
      } else {
        _stopTimer();
        widget.onSave(_currentSeconds);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      widget.onSave(_currentSeconds);
    } else if (state == AppLifecycleState.resumed) {
      if (_isRunning && (_timer == null || !_timer!.isActive)) {
        _startTimer();
      }
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return;
    _lastTickTime ??= DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_isRunning) return;

      final now = DateTime.now();
      final elapsed = now.difference(_lastTickTime!).inSeconds;

      if (elapsed > 0) {
        setState(() {
          _currentSeconds += elapsed;
          _lastTickTime = _lastTickTime!.add(Duration(seconds: elapsed));
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _toggleTimer,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isRunning ? 1.0 : 0.2,
            child: Text(
              formatTime(_currentSeconds),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFeatures: [const FontFeature.tabularFigures()],
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          if (!_isRunning)
            IgnorePointer(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isRunning ? 0.0 : 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'PAUSED',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
