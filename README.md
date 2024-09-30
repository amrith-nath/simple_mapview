# Simple Map View

A simple Flutter project to display and interact with Google Maps.

## Getting Started

This project serves as a starting point for integrating Google Maps into a Flutter application. The app demonstrates how to display a map, control its appearance, and interact with the map's features like markers, zoom controls, and user location.

### Features
- Display Google Maps with initial camera positioning
- Display custom markers to the map
- Show custom location and control Marker zoom levels

### Prerequisites

To use Google Maps in this Flutter app, you'll need to:

1. **Obtain a Google Maps API Key**:
   - Visit the [Google Cloud Console](https://console.cloud.google.com/).
   - Enable the **Maps SDK for Android** and **Maps SDK for iOS**.
   - Generate and copy the API key.

2. **Configure your Android and iOS projects**:
   - For **Android**: Add your API key to the `AndroidManifest.xml` file.
   - For **iOS**: Add your API key to the `Info.plist` file.

3. **Install the required dependencies**:
   - Add `google_maps_flutter` to your `pubspec.yaml` file and run `flutter pub get`.

### Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/your-username/simple-map-view.git
