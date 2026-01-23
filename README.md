![GitHub repo size](https://img.shields.io/github/repo-size/DavidBatkay/cosmic_oracle?style=flat-square)
![GitHub total downloads](https://img.shields.io/github/downloads/DavidBatkay/cosmic_oracle/total?style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/DavidBatkay/cosmic_oracle?style=flat-square)
![GitHub license](https://img.shields.io/github/license/DavidBatkay/cosmic_oracle?style=flat-square)
![GitHub issues](https://img.shields.io/github/issues/DavidBatkay/cosmic_oracle?style=flat-square)
![GitHub stars](https://img.shields.io/github/stars/DavidBatkay/cosmic_oracle?style=flat-square)

# Cosmic Oracle

A cosmic oracle app, helping you make very important decisions.

This project is the final project for the Flutter course in the first semester of the third year of university.

## Demo

https://github.com/user-attachments/assets/fd561be5-f808-4863-9382-d0e60b8675e9

## Project Structure

The project follows a standard Flutter application structure, with the core logic separated into feature-based folders.

```
flutter_final_project/
├── lib/
│   ├── main.dart               # App entry point
│   ├── data.dart               # Contains the prediction data
│   ├── common/
│   │   ├── app_strings.dart    # Centralized app strings
│   │   └── path_strings.dart   # Centralized asset paths
│   ├── models/
│   │   └── prediction_model.dart # Data model for a prediction
│   ├── screens/
│   │   ├── home_screen.dart    # Main screen with the oracle
│   │   └── settings_screen.dart # Screen for app settings
│   └── widgets/
│       ├── paywall_widget.dart   # Widget for premium features
│       └── prediction_widget.dart # Widget to display predictions
├── assets/                     # App images and assets
├── pubspec.yaml                # Dependencies and project configuration
└── ... (platform-specific folders)
```

### Code Organization

-   **`lib/`**: All the Dart code for the application resides here.
-   **`lib/main.dart`**: This is the starting point of the application. It initializes the app and sets up the initial screen.
-   **`lib/common/`**: This directory contains shared code used across the app, such as string constants (`app_strings.dart`) and asset paths (`path_strings.dart`), to avoid hardcoding and ease maintenance.
-   **`lib/models/`**: Contains the data models for the application. `prediction_model.dart` defines the structure of a prediction object.
-   **`lib/screens/`**: This folder holds the different screens of the application. `home_screen.dart` is the main screen where the user interacts with the magic 8-ball, and `settings_screen.dart` allows the user to configure the app.
-   **`lib/widgets/`**: Contains reusable UI components. `prediction_widget.dart` is used to display the oracle's prediction, and `paywall_widget.dart` is a component for a potential premium version.
-   **`assets/`**: This directory contains all the static assets used in the app, such as images.

## Dependencies

The project relies on the following key packages:

-   [`sensors_plus`](https://pub.dev/packages/sensors_plus): To access accelerometer and gyroscope data, allowing the user to shake the device to get a prediction.
-   [`shared_preferences`](https://pub.dev/packages/shared_preferences): For persisting simple data, like user settings.

## How to Run

To run this project, you need to have Flutter installed.

1.  Clone the repository:
    ```bash
    git clone <repository-url>
    ```
2.  Navigate to the project directory:
    ```bash
    cd flutter_final_project
    ```
3.  Install dependencies:
    ```bash
    flutter pub get
    ```
4.  Run the app:
    ```bash
    flutter run
    ```
