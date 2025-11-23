# RAFEEQ

RAFEEQ - Student housing, services, wallet, and student-to-student market platform.

## Description

RAFEEQ is a comprehensive Flutter application designed for students, providing:
- **Student Housing**: Find and list housing options near the university
- **Services**: Access various student services
- **Wallet**: Digital wallet functionality for transactions
- **Student Market**: Buy and sell products between students
- **Chat**: Communication features for users
- **Multi-language Support**: English and Arabic (RTL support)

## Features

- 🏠 Housing listings and management
- 💼 Service provider features
- 💰 Digital wallet with card management
- 🛒 Student-to-student marketplace
- 💬 In-app messaging
- 🌐 Multi-language support (English/Arabic)
- 🎨 Modern Material Design UI
- 🌓 Dark mode support

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0 <4.0.0)
- Dart SDK
- Android Studio / VS Code
- Chrome (for web development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd rafeeq
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For web
flutter run -d chrome

# For Android (with connected device or emulator)
flutter run -d android

# For iOS (macOS only)
flutter run -d ios
```

## Running on Android Devices

### Option 1: Using a Physical Android Device

1. **Enable Developer Options on your Android device:**
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Go back to Settings → Developer Options
   - Enable "USB Debugging"

2. **Connect your device via USB:**
   - Connect your Android device to your computer
   - Accept the USB debugging prompt on your device

3. **Verify device connection:**
   ```bash
   flutter devices
   ```
   You should see your Android device listed.

4. **Run the app:**
   ```bash
   flutter run -d android
   ```

### Option 2: Using an Android Emulator

1. **Create an Android Virtual Device (AVD):**
   - Open Android Studio
   - Go to Tools → Device Manager
   - Click "Create Device"
   - Select a device (e.g., Pixel 5)
   - Download a system image (e.g., Android 13)
   - Finish the setup

2. **Start the emulator:**
   - Launch the emulator from Android Studio, or
   ```bash
   flutter emulators --launch <emulator_id>
   ```

3. **Run the app:**
   ```bash
   flutter run -d android
   ```

### Option 3: Build APK for Installation

1. **Build a debug APK:**
   ```bash
   flutter build apk --debug
   ```
   The APK will be located at: `build/app/outputs/flutter-apk/app-debug.apk`

2. **Build a release APK:**
   ```bash
   flutter build apk --release
   ```
   The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

3. **Install the APK:**
   - Transfer the APK to your Android device
   - Enable "Install from Unknown Sources" in Settings
   - Open the APK file and install

### Android Permissions

The app requires the following permissions (already configured):
- Internet access
- Location services (for housing listings)
- Camera (for image picker)
- Storage access (for images)

These permissions are automatically requested when needed.

## Project Structure

```
lib/
├── core/           # Core functionality (providers, theme, utils)
├── features/        # Feature modules (market, chat)
├── screens/         # App screens
└── main.dart        # App entry point
```

## Technologies Used

- Flutter
- Provider (State Management)
- Firebase (Optional - currently disabled)
- SharedPreferences (Local storage)
- Material Design 3

## License

This project is private and proprietary.

## Team Collaboration

This project uses Git and GitHub for version control. For detailed collaboration instructions, see [CONTRIBUTING.md](CONTRIBUTING.md).

### Quick Start for Team Members

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/rafeeq.git
   cd rafeeq
   flutter pub get
   ```

2. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make changes, commit, and push:**
   ```bash
   git add .
   git commit -m "Description of changes"
   git push origin feature/your-feature-name
   ```

4. **Create a Pull Request on GitHub** for code review

### Branch Protection

- The `main` branch is protected
- All changes must go through Pull Requests
- Code review required before merging

## Contact

For more information, visit: https://rafeeq.asu.edu.jo
