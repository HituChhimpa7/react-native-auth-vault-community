# 🛡️ react-native-auth-vault

<p align="center">
  <a href="https://github.com/HituChhimpa7/react-native-auth-vault-community">
    <img src="https://raw.githubusercontent.com/HituChhimpa7/react-native-auth-vault-community/main/assets/auth_vault_mockup.png" width="480" alt="react-native-auth-vault mockup" />
  </a>
</p>

<p align="center">
  <strong>Simple, hardware-backed authentication and mobile security for React Native & Expo.</strong>
</p>

<p align="center">
  <a href="https://www.npmjs.com/package/@hituchhimpa/react-native-auth-vault"><img src="https://img.shields.io/npm/v/@hituchhimpa/react-native-auth-vault.svg?style=flat-square&color=blue" alt="npm version" /></a>
  <a href="https://www.npmjs.com/package/@hituchhimpa/react-native-auth-vault"><img src="https://img.shields.io/npm/dm/@hituchhimpa/react-native-auth-vault.svg?style=flat-square&color=green" alt="npm downloads" /></a>
  <a href="https://github.com/HituChhimpa7/react-native-auth-vault-community/blob/main/LICENSE"><img src="https://img.shields.io/github/license/HituChhimpa7/react-native-auth-vault-community?style=flat-square" alt="license" /></a>
  <a href="https://reactnative.dev"><img src="https://img.shields.io/badge/platform-iOS%20%7C%20Android-lightgrey?style=flat-square" alt="Platform" /></a>
  <a href="https://expo.dev"><img src="https://img.shields.io/badge/Expo-compatible-purple?style=flat-square" alt="Expo" /></a>
  <a href="https://reactnative.dev/docs/the-new-architecture/landing-page"><img src="https://img.shields.io/badge/New%20Architecture-supported-brightgreen?style=flat-square" alt="New Architecture" /></a>
</p>

---

## Overview

Most React Native applications require multiple packages to handle biometric authentication, secure token storage, device security checks, and screen masking in the app switcher.

**`react-native-auth-vault`** combines these core security needs into a single native library. It uses platform-native hardware primitives (Apple Secure Enclave and Android Keystore/StrongBox) with a fast, zero-bridge TurboModule architecture.

### ✨ Key Features

- 🔐 **Hardware Storage**: AES-256 encryption backed by iOS Secure Enclave and Android Keystore/StrongBox.
- 👆 **Biometrics**: Face ID, Touch ID, Android BiometricPrompt, and device passcode fallback.
- 🛡️ **Security Audit**: Instant detection of root, jailbreak, emulators, debuggers, and hooking engines (Frida/Xposed).
- 🔏 **Hardware Signing**: Asymmetric P-256 ECDSA keypair generation and request signing inside hardware chips.
- 📱 **Privacy Protection**: Automatic App Switcher blur (iOS) and screenshot blocking / tapjacking defense (Android).
- 🧠 **Secure Memory**: Isolated native memory storage to prevent sensitive tokens from residing in the JavaScript heap.
- ⚡ **Modern Architecture**: Out-of-the-box support for React Native New Architecture (TurboModules & JSI) and Expo.

---

## ⚡ Quick Start

```typescript
import { AuthVault } from '@hituchhimpa/react-native-auth-vault';

// 1. Store a secret with biometric protection
await AuthVault.setItem(
  'user_token',
  'secret-access-token',
  'Authenticate to save credentials'
);

// 2. Retrieve the secret (prompts user for Face ID / Fingerprint)
const token = await AuthVault.getItem('user_token', 'Authenticate to continue');

// 3. Perform a device security check
const posture = AuthVault.audit();
if (posture.jailbroken || posture.rooted) {
  console.warn('Untrusted device detected');
}
```

---

## 📊 Feature Comparison

| Feature | `react-native-keychain` | `react-native-biometrics` | `react-native-encrypted-storage` | **Auth Vault** |
| :--- | :---: | :---: | :---: | :---: |
| **Hardware Encryption (AES-256)** | ✅ | ⚠️ Partial | ❌ | **✅** |
| **Secure Enclave / StrongBox** | ✅ | ⚠️ Partial | ❌ | **✅** |
| **Biometric Authentication** | ✅ | ✅ | ❌ | **✅** |
| **Root & Jailbreak Detection** | ❌ | ❌ | ❌ | **✅** |
| **Frida & Xposed Hooking Detection** | ❌ | ❌ | ❌ | **✅** |
| **Hardware Asymmetric Signing** | ❌ | ❌ | ❌ | **✅** |
| **Privacy Screen & Tapjacking Defense** | ❌ | ❌ | ❌ | **✅** |
| **Secure Native Memory Storage** | ❌ | ❌ | ❌ | **✅** |
| **Expo Config Plugin** | ❌ | ❌ | ❌ | **✅** |
| **TurboModules (New Architecture)** | ❌ | ❌ | ❌ | **✅** |

---

## 📦 Installation

```bash
# npm
npm install @hituchhimpa/react-native-auth-vault

# yarn
yarn add @hituchhimpa/react-native-auth-vault

# pnpm
pnpm add @hituchhimpa/react-native-auth-vault
```

---

## ⚙️ Setup

### ⚡ Expo
Add the plugin to your `app.json` or `app.config.js`:

```json
{
  "expo": {
    "plugins": [
      [
        "@hituchhimpa/react-native-auth-vault",
        {
          "faceIDPermission": "Allow $(PRODUCT_NAME) to use Face ID for secure authentication."
        }
      ]
    ]
  }
}
```
Then run:
```bash
npx expo prebuild
```

### 📱 iOS (React Native CLI)
Install pods and configure permissions:
```bash
cd ios && pod install
```
Add `NSFaceIDUsageDescription` to your `Info.plist`:
```xml
<key>NSFaceIDUsageDescription</key>
<string>This app uses Face ID to securely authenticate users.</string>
```

### 🤖 Android (React Native CLI)
No manual manifest setup required. Ensure your project target has `minSdkVersion = 24`.

---

## 📖 API Reference

### Secure Storage

#### `AuthVault.setItem(key: string, value: string, prompt: string): Promise<boolean>`
Stores an encrypted key-value pair. Pass `""` for `prompt` to store silently without showing a biometric dialog.

#### `AuthVault.getItem(key: string, prompt: string): Promise<string | null>`
Retrieves and decrypts a stored item. Returns `null` if not found or if authentication is cancelled.

#### `AuthVault.removeItem(key: string): Promise<boolean>`
Removes the stored item and deletes its associated cryptographic key.

---

### Security Auditing

#### `AuthVault.audit(): SecurityPosture`
Synchronously checks device security integrity.

```typescript
const posture = AuthVault.audit();
```

Return object properties:
- `securityScore`: `number` (0–100 score).
- `jailbroken` / `rooted`: `boolean` (Device integrity status).
- `emulator` / `debuggerAttached`: `boolean` (Development environment checks).
- `hookingDetected`: `boolean` (Active memory hook detection).
- `biometricEnabled` / `hardwareBacked`: `boolean` (Hardware capabilities).

---

### Privacy & UI Shields

#### `AuthVault.setPrivacyScreenEnabled(enabled: boolean): void`
Prevents screenshots on Android and adds a blur overlay in the iOS App Switcher.

#### `AuthVault.setOverlayProtectionEnabled(enabled: boolean): void`
*(Android)* Prevents tapjacking by dropping touch events when another app window overlays the screen.

---

### Asymmetric Signing

#### `AuthVault.generateSigningKeyPair(tag: string): Promise<string>`
Generates a P-256 ECC key pair inside hardware and returns the public key in Base64 format.

#### `AuthVault.signData(tag: string, data: string): Promise<string>`
Signs text data using the private key associated with `tag` and returns the cryptographic signature.

---

## 💡 Practical App Example

```typescript
import React, { useEffect } from 'react';
import { Alert, BackHandler } from 'react-native';
import { AuthVault } from '@hituchhimpa/react-native-auth-vault';

export default function App() {
  useEffect(() => {
    // Audit security at startup
    const posture = AuthVault.audit();
    if (posture.jailbroken || posture.rooted) {
      Alert.alert('Security Notice', 'App cannot run on rooted or jailbroken devices.', [
        { text: 'OK', onPress: () => BackHandler.exitApp() },
      ]);
      return;
    }

    // Enable screen protection
    AuthVault.setPrivacyScreenEnabled(true);
  }, []);

  return <YourAppNavigator />;
}
```

---

## 📄 License

MIT © [Hitesh Chhimpa](https://github.com/HituChhimpa7)
