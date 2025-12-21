import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ValueIncrementer extends StatelessWidget {
  final TextEditingController controller;
  final double incrementValue;
  final bool isDecimal;

  const ValueIncrementer({
    super.key,
    required this.controller,
    this.incrementValue = 1.0,
    this.isDecimal = false,
  });

  void _increment() {
    final currentValue = double.tryParse(controller.text) ?? 0.0;
    final newValue = currentValue + incrementValue;
    // Format the string to avoid unnecessary decimals for integers
    controller.text = isDecimal
        ? newValue.toStringAsFixed(2)
        : newValue.toInt().toString();
  }

  void _decrement() {
    final currentValue = double.tryParse(controller.text) ?? 0.0;
    final newValue = currentValue - incrementValue;
    if (newValue >= 0) {
      // Don't allow negative values
      controller.text = isDecimal
          ? newValue.toStringAsFixed(2)
          : newValue.toInt().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // --- Minus Button ---
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: _decrement,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),

        // --- TextField ---
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center, // Center the text
            decoration: const InputDecoration(border: OutlineInputBorder()),
            keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
            inputFormatters: isDecimal
                ? [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))]
                : [FilteringTextInputFormatter.digitsOnly],
          ),
        ),

        // --- Plus Button ---
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: _increment,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
