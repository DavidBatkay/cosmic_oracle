import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common/app_strings.dart';
import 'data.dart';
import 'screens/home_screen.dart';

/// The main entry point of the application.
Future<void> main() async {
  // Ensure that the Flutter binding is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  // Set the application to run in immersive sticky mode, which hides the system UI.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Initialize the data manager to load prediction data.
  await DataManager().init();
  // Run the main application widget.
  runApp(const MainApp());
}

/// The root widget of the application.
class MainApp extends StatelessWidget {
  /// Creates the main application widget.
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
