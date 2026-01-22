import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/app_strings.dart';
import 'models/prediction_model.dart';

/// The default list of predictions for a classic 8-ball.
List<Prediction> defaultPredictions = [
  Prediction(text: AppStrings.yes, color: Colors.green),
  Prediction(text: AppStrings.no, color: Colors.red),
  Prediction(text: AppStrings.maybe, color: Colors.orange),
  Prediction(text: AppStrings.askAgainLater, color: Colors.blue),
  Prediction(text: AppStrings.itIsUnclear, color: Colors.purple),
];

/// Represents a single prediction configuration, including its title and a list of possible predictions.
class PredictionConfig {
  String id;
  String title;
  List<Prediction> predictions;
  bool isDefault;

  PredictionConfig({
    required this.id,
    required this.title,
    required this.predictions,
    this.isDefault = false,
  });

  /// Converts the [PredictionConfig] to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'predictions': predictions.map((p) => p.toJson()).toList(),
        'isDefault': isDefault,
      };

  /// Creates a [PredictionConfig] from a JSON object.
  factory PredictionConfig.fromJson(Map<String, dynamic> json) {
    return PredictionConfig(
      id: json['id'],
      title: json['title'],
      predictions: (json['predictions'] as List)
          .map((p) => Prediction.fromJson(p))
          .toList(),
      isDefault: json['isDefault'] ?? false,
    );
  }
}

/// A singleton class for managing application data, including prediction configurations and premium status.
class DataManager {
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  /// Whether the user has premium access.
  bool isPremium = false;

  /// The list of all prediction configurations.
  List<PredictionConfig> configs = [];

  /// The ID of the currently active prediction configuration.
  String activeConfigId = AppStrings.defaultString;

  /// The currently active prediction configuration.
  PredictionConfig get activeConfig {
    return configs.firstWhere(
      (c) => c.id == activeConfigId,
      orElse: () => configs.firstWhere(
        (c) => c.isDefault,
        orElse: () => PredictionConfig(
          id: AppStrings.defaultString,
          title: AppStrings.classic8Ball,
          predictions: defaultPredictions,
          isDefault: true,
        ),
      ),
    );
  }

  /// Initializes the data manager by loading data from shared preferences.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    isPremium = prefs.getBool(AppStrings.isPremium) ?? false;
    activeConfigId =
        prefs.getString(AppStrings.activeConfigId) ?? AppStrings.defaultString;

    final String? configsJson = prefs.getString(AppStrings.configs);
    if (configsJson != null) {
      try {
        List<dynamic> decoded = jsonDecode(configsJson);
        configs = decoded.map((d) => PredictionConfig.fromJson(d)).toList();
      } catch (e) {
        _initDefault();
      }
    } else {
      _initDefault();
    }
  }

  /// Initializes the default prediction configuration.
  void _initDefault() {
    configs = [
      PredictionConfig(
        id: AppStrings.defaultString,
        title: AppStrings.classic8Ball,
        predictions: List.from(defaultPredictions),
        isDefault: true,
      ),
    ];
  }

  /// Sets the user's premium status and saves it to shared preferences.
  Future<void> setPremium(bool value) async {
    isPremium = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStrings.isPremium, value);
  }

  /// Sets the active prediction configuration and saves it to shared preferences.
  Future<void> setActiveConfig(String id) async {
    activeConfigId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStrings.activeConfigId, activeConfigId);
  }

  /// Saves the current application data to shared preferences.
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(configs.map((c) => c.toJson()).toList());
    await prefs.setString(AppStrings.configs, json);
    await prefs.setString(AppStrings.activeConfigId, activeConfigId);
  }
}
