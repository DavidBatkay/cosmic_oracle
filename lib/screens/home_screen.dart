import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/prediction_model.dart';
import '../data.dart';
import 'settings_screen.dart';
import '../widgets/prediction_widget.dart';
import '../common/app_strings.dart';
import '../common/path_strings.dart';

/// The main screen of the application, displaying the magic 8-ball and predictions.
class HomeScreen extends StatefulWidget {
  /// Creates the home screen widget.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Prediction? currentPrediction;
  double _opacity = 1.0;
  StreamSubscription? _subscription;
  DateTime _lastShakeTime = DateTime.now();
  late AnimationController _animController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pageController = PageController();
    _subscription = accelerometerEventStream().listen((event) {
      final acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (acceleration > 45) {
        final now = DateTime.now();
        if (now.difference(_lastShakeTime).inSeconds > 1) {
          if (_pageController.hasClients &&
              _pageController.page?.round() == 0) {
            _lastShakeTime = now;
            shakeBall();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  /// Animates the ball shaking and reveals a new prediction.
  void shakeBall() {
    _animController.forward(from: 0.0);
    setState(() {
      _opacity = 0.0;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        final predictions = DataManager().activeConfig.predictions;
        currentPrediction = predictions.isNotEmpty
            ? predictions[Random().nextInt(predictions.length)]
            : null;
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.appTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  _pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(PathStrings.starsAsset),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: shakeBall,
                    child: AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        final offset =
                            sin(_animController.value * 2 * pi * 3) * 10;
                        return Transform.translate(
                          offset: Offset(offset, 0),
                          child: child,
                        );
                      },
                      child: Stack(
                        alignment: const Alignment(0, -0.15),
                        children: [
                          Image.asset(
                            PathStrings.magicBallAsset,
                            width: 334,
                          ),
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF101020,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[900]!,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: _opacity,
                                  child: PredictionWidget(
                                      prediction: currentPrediction),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.8),
                                      ],
                                      stops: const [0.5, 1.0],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    AppStrings.shakeInstructions,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SettingsScreen(),
      ],
    );
  }
}
