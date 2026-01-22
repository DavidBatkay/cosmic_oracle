import 'package:flutter/material.dart';
import '../common/app_strings.dart';
import '../data.dart';

/// A widget that displays a paywall for upgrading to the premium version.
class PaywallWidget extends StatelessWidget {
  /// A callback function that is called when the user successfully upgrades.
  final VoidCallback onUpgrade;

  /// Creates a paywall widget.
  const PaywallWidget({super.key, required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.diamond, size: 80, color: Colors.amber),
            const SizedBox(height: 20),
            const Text(
              AppStrings.unlockCosmicPowers,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              AppStrings.customConfigurations,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              onPressed: () async {
                await DataManager().setPremium(true);
                onUpgrade();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(AppStrings.welcomeToPro)),
                  );
                }
              },
              child: const Text(
                AppStrings.upgradeToProPrice,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
