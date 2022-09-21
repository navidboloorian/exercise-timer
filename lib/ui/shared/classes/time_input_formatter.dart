import 'dart:math' as math;

import 'package:flutter/services.dart';

class TimerInputFormatter extends TextInputFormatter {
  final RegExp _expression;
  TimerInputFormatter() : _expression = RegExp(r'^[0-9:]+$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_expression.hasMatch(newValue.text)) {
      TextSelection newSelection = newValue.selection;

      String value = newValue.text;
      String newText;

      String leftSubstring = '';
      String rightSubstring = '';

      if (value.length >= 5) {
        if (value.substring(0, 4) == '00:0') {
          leftSubstring = '00:';
          rightSubstring =
              value.substring(leftSubstring.length + 1, value.length);
        } else if (value.substring(0, 3) == '00:') {
          leftSubstring = '0';
          rightSubstring = '${value.substring(3, 4)}:${value.substring(4)}';
        } else {
          leftSubstring = '';
          rightSubstring =
              '${value.substring(1, 2)}${value.substring(3, 4)}:${value.substring(4)}';
        }
      } else if (value.length == 4) {
        if (value.substring(0, 4) == '00:0') {
          leftSubstring = '';
          rightSubstring = '';
        } else if (value.substring(0, 3) == '00:') {
          leftSubstring = '00:0';
          rightSubstring = value.substring(3, 4);
        } else {
          leftSubstring = '00';
          rightSubstring =
              ':${value.substring(1, 2)}${value.substring(3, 4)}${value.substring(4)}';
        }
      } else {
        leftSubstring = '00:0';
        rightSubstring = value;
      }

      if (oldValue.text.isNotEmpty && oldValue.text.substring(0, 1) != '0') {
        if (value.length > 4) {
          return oldValue;
        } else {
          leftSubstring = '0';
          rightSubstring =
              '${value.substring(0, 1)}:${value.substring(1, 2)}${value.substring(3)}';
        }
      }

      newText = leftSubstring + rightSubstring;

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(newText.length, newText.length),
        extentOffset: math.min(newText.length, newText.length),
      );

      return TextEditingValue(
        text: newText,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }

    return oldValue;
  }
}
