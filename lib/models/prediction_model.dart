import 'package:flutter/material.dart';

/// Represents a single prediction with its text and color.
class Prediction {
  /// The text of the prediction.
  String text;
  /// The color of the prediction text.
  Color color;

  /// Creates a new prediction.
  Prediction({required this.text, this.color = Colors.blue});

  /// Converts the [Prediction] to a JSON object.
  Map<String, dynamic> toJson() => {
    'text': text,
    'color': color.value,
  };

  /// Creates a [Prediction] from a JSON object.
  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      text: json['text'],
      color: Color(json['color']),
    );
  }
}
