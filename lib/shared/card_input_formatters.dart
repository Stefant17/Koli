import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String newString = '';
    for(var i = 0; i < text.length; i++) {
      newString += text[i];
      if((i + 1) % 4 == 0 && (i + 1) != text.length) {
        newString += ' ';
      }
    }

    return newValue.copyWith(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length)
    );
  }
}

class CardDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String newString = '';
    for(var i = 0; i < text.length; i++) {
      newString += text[i];
      if((i + 1) == 2) {
        newString += '/';
      }
    }

    return newValue.copyWith(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length)
    );
  }
}