#!/bin/bash

echo "🔨 Building HomeStock for all platforms..."

# Web
echo "📱 Building Web..."
flutter build web --release --no-pub
echo "✅ Web build complete"

# Android
echo "📱 Building Android..."
flutter build apk --release
echo "✅ Android APK: build/app/outputs/flutter-apk/app-release.apk"

# iOS (requires macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "📱 Building iOS..."
    flutter build ios --release
    echo "✅ iOS build complete"
fi

echo "🎉 All builds complete!"
