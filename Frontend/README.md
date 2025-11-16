# CareConnect Flutter App

Frontend mobile application for CareConnect - Smart Healthcare Coordination Platform

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Check Flutter installation**
```bash
flutter --version
flutter doctor
```

2. **Install dependencies**
```bash
cd Frontend
flutter pub get
```

3. **Configure Backend URL**
Edit `lib/config/api_constants.dart` and update:
```dart
static const String baseUrl = 'http://YOUR_BACKEND_URL/api';
// For local: 'http://localhost:5000/api'
// For Android emulator: 'http://10.0.2.2:5000/api'
// For deployed: 'https://your-app.onrender.com/api'
```

4. **Run the app**
```bash
# List available devices
flutter devices

# Run on connected device
flutter run

# Run on specific device
flutter run -d <device-id>

# Run on Chrome (web)
flutter run -d chrome
```

## 📱 Features

### Patient Module
- ✅ Register and login
- ✅ Search doctors by specialization and location
- ✅ Book appointments
- ✅ View appointment history
- ✅ Search medicine availability
- ✅ Medical records management

### Doctor Module
- ✅ Register and login
- ✅ View appointments
- ✅ Access patient history
- ✅ Create prescriptions
- ✅ Manage availability

### Pharmacist Module
- ✅ Register and login
- ✅ Manage inventory
- ✅ Add/Update medicines
- ✅ Track stock and expiry dates

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── config/
│   └── api_constants.dart       # API endpoints
├── models/
│   ├── user_model.dart
│   ├── doctor_model.dart
│   ├── appointment_model.dart
│   └── pharmacy_model.dart
├── providers/                   # State management
│   ├── auth_provider.dart
│   ├── doctor_provider.dart
│   ├── appointment_provider.dart
│   └── pharmacy_provider.dart
├── services/
│   └── api_service.dart         # HTTP requests
├── screens/
│   ├── splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── patient/
│   │   ├── patient_dashboard.dart
│   │   ├── doctor_list_screen.dart
│   │   ├── book_appointment_screen.dart
│   │   └── search_medicine_screen.dart
│   ├── doctor/
│   │   ├── doctor_dashboard.dart
│   │   ├── appointments_list_screen.dart
│   │   └── create_prescription_screen.dart
│   └── pharmacist/
│       ├── pharmacist_dashboard.dart
│       └── manage_inventory_screen.dart
└── widgets/                     # Reusable widgets
    ├── custom_button.dart
    └── custom_text_field.dart
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: shared_preferences
- **UI**: Material Design

## 🔧 Configuration

### Android Configuration
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### iOS Configuration
Edit `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to find nearby doctors and pharmacies</string>
```

## 🐛 Troubleshooting

### Common Issues

1. **Package errors**
```bash
flutter clean
flutter pub get
```

2. **Build errors**
```bash
flutter pub upgrade
flutter build <platform>
```

3. **Network issues (Android Emulator)**
- Use `http://10.0.2.2:5000` instead of `localhost:5000`

4. **Hot reload not working**
- Press 'r' in terminal for hot reload
- Press 'R' for full restart

## 📦 Build for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🚀 Deployment

### Web Hosting (Free Options)
1. **Firebase Hosting**
   ```bash
   firebase init hosting
   firebase deploy
   ```

2. **GitHub Pages**
   ```bash
   flutter build web
   # Push build/web to gh-pages branch
   ```

3. **Netlify**
   - Drag and drop `build/web` folder

### Mobile App Stores
- **Google Play**: Follow [Flutter deployment guide](https://flutter.dev/docs/deployment/android)
- **Apple App Store**: Follow [Flutter deployment guide](https://flutter.dev/docs/deployment/ios)

## 📝 Environment Variables

Create `.env` file (optional):
```
API_BASE_URL=https://your-backend.com/api
GOOGLE_MAPS_API_KEY=your_key_here
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📄 License

MIT
