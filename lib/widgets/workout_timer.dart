import 'dart:async';

import 'package:flutter/material.dart';

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
  DateTime? _pauseTimeAppBackground;

  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _currentSeconds = widget.initialSeconds;
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  // Přepínání stavu po kliknutí na časovač
  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _pauseTimeAppBackground = null;
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
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      if (_isRunning && _pauseTimeAppBackground == null) {
        _stopTimer();
        _pauseTimeAppBackground = DateTime.now();
      }
      widget.onSave(_currentSeconds);
    } else if (state == AppLifecycleState.resumed) {
      if (_isRunning && _pauseTimeAppBackground != null) {
        final resumeDifference = DateTime.now()
            .difference(_pauseTimeAppBackground!)
            .inSeconds;
        _currentSeconds += resumeDifference;
        _pauseTimeAppBackground = null;
        _startTimer();
      }
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

    if (d.inHours > 0) {
      return "${fmt(d.inHours)}:${fmt(d.inMinutes.remainder(60))}:${fmt(d.inSeconds.remainder(60))}";
    } else {
      return "${fmt(d.inMinutes.remainder(60))}:${fmt(d.inSeconds.remainder(60))}";
    }
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
              _formatTime(_currentSeconds),
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
