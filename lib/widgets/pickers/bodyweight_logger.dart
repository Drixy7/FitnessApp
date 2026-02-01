import 'package:fitness_app/models/weight_log.dart';
import 'package:fitness_app/providers/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Ensure you have this for date formatting

class BodyWeightLogger extends StatefulWidget {
  final WeightLog? initialWeightLog;
  const BodyWeightLogger({super.key, this.initialWeightLog});

  @override
  State<BodyWeightLogger> createState() => _BodyWeightLoggerState();
}

class _BodyWeightLoggerState extends State<BodyWeightLogger> {
  final TextEditingController _weightController = TextEditingController();
  late DateTime _selectedDate;
  WeightLog? _currentLog;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialWeightLog?.date ?? DateTime.now();
    _currentLog = widget.initialWeightLog;
    if (_currentLog != null) {
      _weightController.text = _currentLog!.weight.toString();
    }
  }

  Future<void> _changeDay(int daysToAdd) async {
    final newDate = _selectedDate.add(Duration(days: daysToAdd));

    setState(() {
      _selectedDate = newDate;
    });
    final foundLog = await context.read<IsarService>().findWeightLogForDate(
      newDate,
    );
    if (mounted) {
      setState(() {
        _currentLog = foundLog;
        if (foundLog != null) {
          _weightController.text = foundLog.weight.toString();
        } else {
          _weightController.clear();
        }
      });
    }
  }

  Future<void> _saveLog() async {
    if (_weightController.text.isEmpty) return;

    final weight = double.tryParse(_weightController.text);
    if (weight == null || weight == 0.0) return;

    final isarService = context.read<IsarService>();

    final logToSave = _currentLog ?? WeightLog()
      ..date = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );

    logToSave.weight = weight;

    await isarService.saveWeightLog(logToSave);

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    final text = _weightController.text;
    if (text.isEmpty) return false;
    final value = double.tryParse(text);
    return value != null && value > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: () {
                  _changeDay(-1);
                },
              ),
              Text(
                DateFormat.yMMMd().format(_selectedDate),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 20),
                onPressed: () {
                  setState(() {
                    _changeDay(1);
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          TextField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              suffixText: "kg",
              suffixStyle: TextStyle(fontSize: 24, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (val) => setState(() {}),
            autofocus: true,
          ),

          const SizedBox(height: 20),

          // --- BUTTON: Log Weight ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _canSubmit ? () => _saveLog() : null,
              child: const Text(
                "LOG WEIGHT",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
