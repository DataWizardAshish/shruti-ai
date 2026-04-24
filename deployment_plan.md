# Shruti — Real-Device Testing & Play Store Deployment Plan

## Critical Blocker: Backend URL

`api_service.dart` hardcodes `http://localhost:8000`. Works on Chrome (same machine), breaks on any real device.

| Stage | URL to use |
|---|---|
| Physical phone (same WiFi) | `http://192.168.1.X:8000` (your PC's IP) |
| Android emulator | `http://10.0.2.2:8000` |
| Play Store release | Deployed server URL (Railway / Render / VPS) |

---

## Part 1 — Real-Device Testing (Physical Phone)

### Step 1: Enable Developer Mode on phone
- Settings → About Phone → tap **Build Number** 7 times
- Settings → Developer Options → turn on **USB Debugging**

### Step 2: Connect phone via USB
```bash
flutter devices
```
Phone appears in list. If not, install USB driver for your phone brand.

### Step 3: Find PC's local IP
```bash
ipconfig
```
Look for IPv4 on WiFi adapter (e.g. `192.168.1.42`).

### Step 4: Update backend URL
File: `app/lib/services/api_service.dart`
```dart
static const _baseUrl = 'http://192.168.1.42:8000';  // replace with your IP
```

### Step 5: Start FastAPI bound to all interfaces
```bash
uvicorn src.api:app --host 0.0.0.0 --port 8000
```
Default `127.0.0.1` rejects phone connections — must use `0.0.0.0`.

### Step 6: Add INTERNET permission (currently missing)
File: `app/android/app/src/main/AndroidManifest.xml`
Inside `<manifest>` tag, add:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### Step 7: Run on device
```bash
flutter run -d <device-id>
```

---

## Part 1B — Emulator Testing (No Phone Needed)

Install Android Studio to get AVD Manager, or use command-line tools:
```bash
sdkmanager "system-images;android-34;google_apis;x86_64"
avdmanager create avd -n shruti_test -k "system-images;android-34;google_apis;x86_64"
emulator -avd shruti_test
```

Emulator reaches host machine at `10.0.2.2`:
```dart
static const _baseUrl = 'http://10.0.2.2:8000';
```

---

## Part 2 — Play Store Submission

### Checklist

| Item | Current State | Action |
|---|---|---|
| applicationId | `com.shruti.shruti` | Consider `com.imashisht.shruti` |
| Version | `1.0.0+1` | OK for first submission |
| INTERNET permission | Missing | Add to AndroidManifest |
| App icon | Flutter default blue | Replace with Shruti icon |
| Signing keystore | Not created | Create once, store safely |
| Backend URL | localhost:8000 | **Deploy to real server first** |
| Play Console account | Unknown | $25 one-time fee |

---

### Step A: Deploy backend to real server

Required before Play Store — users can't reach your PC.

**Railway (free tier, easiest):**
1. Push `content_generation/` to GitHub
2. railway.app → New Project → Deploy from GitHub
3. Set env vars, get HTTPS URL like `https://shruti-api.up.railway.app`
4. Update `_baseUrl` in `api_service.dart`

---

### Step B: Add INTERNET permission
File: `app/android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

---

### Step C: Create signing keystore
Run once. **Back up this file — losing it means you can never update the app.**
```bash
keytool -genkey -v -keystore ~/shruti-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias shruti
```

---

### Step D: Create `app/android/key.properties`
```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=shruti
storeFile=C:/Users/triveash/shruti-release.jks
```
**Never commit this file to git.** Add `key.properties` to `.gitignore`.

---

### Step E: Wire signing into `app/android/app/build.gradle.kts`

Add before `android {` block:
```kotlin
val keyProperties = Properties()
val keyPropertiesFile = rootProject.file("key.properties")
if (keyPropertiesFile.exists()) {
    keyPropertiesFile.inputStream().use { keyProperties.load(it) }
}
```

Add inside `android {` block:
```kotlin
signingConfigs {
    create("release") {
        keyAlias = keyProperties["keyAlias"] as String
        keyPassword = keyProperties["keyPassword"] as String
        storeFile = file(keyProperties["storeFile"] as String)
        storePassword = keyProperties["storePassword"] as String
    }
}
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = false
    }
}
```

---

### Step F: Replace app icon

Need 1024×1024 PNG with Shruti branding (saffron / temple red).

Using `flutter_launcher_icons`:
1. Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.1

flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/images/icon.png"
```
2. Place your icon at `app/assets/images/icon.png`
3. Run:
```bash
dart run flutter_launcher_icons
```

---

### Step G: Build release AAB
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

AAB is required for Play Store (APK no longer accepted for new apps).

---

### Step H: Submit to Play Console

1. Register at play.google.com/console — $25 one-time fee
2. Create app → name "Shruti", category "Education"
3. Upload AAB to **Internal Testing** track first (test with your own Gmail)
4. Fill store listing:
   - Short description (80 chars)
   - Full description
   - Screenshots — minimum 2 phone screenshots
   - Feature graphic (1024×500 px)
5. Content rating questionnaire
6. Pricing: Free
7. Submit for review — typically 1–3 days

---

## Recommended Order

1. Add INTERNET permission → test on physical phone (30 min)
2. Deploy FastAPI backend to Railway (1–2 hrs)
3. Create keystore + signing config (20 min)
4. Design app icon, generate with flutter_launcher_icons (varies)
5. Build AAB, register Play Console, submit (2–3 hrs)

---

## Files to Modify

| File | Change |
|---|---|
| `app/android/app/src/main/AndroidManifest.xml` | Add INTERNET permission |
| `app/lib/services/api_service.dart` | Update `_baseUrl` |
| `app/android/app/build.gradle.kts` | Add signing config |
| `app/android/key.properties` | Create (never commit) |
| `app/pubspec.yaml` | Add flutter_launcher_icons |
| `app/assets/images/icon.png` | Place your icon here |
