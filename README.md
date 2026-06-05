# 🛡️ React Native Auth Vault

A native-first security and authentication library for React Native that leverages the Android Keystore, StrongBox, and iOS Secure Enclave to protect sensitive application data.

Built for applications that require secure credential storage, biometric authentication, encrypted local secrets, and runtime security auditing.

---

## Why Auth Vault?

Most secure-storage libraries only encrypt data. Auth Vault goes further by:

* 🔐 **Hardware-Backed Protection**: Keeping cryptographic keys inside hardware-backed security modules whenever available.
* 👆 **Biometrics Integration**: Supporting Face ID, Touch ID, and Android Biometrics out of the box.
* ⚡ **Silent Encryption**: Allowing silent encryption for background operations without showing user prompts.
* 🛡️ **Security Posture Checks**: Auditing device security posture before performing sensitive actions.
* 🧵 **Native Performance**: Executing cryptographic operations natively on separate threads for improved performance.

---

## ✨ Features

### 🔑 Hardware-Backed Key Protection
Uses Android Keystore (TEE/StrongBox) and iOS Secure Enclave to generate and protect encryption keys.

### 👤 Biometric Authentication
Authenticate using Face ID, Touch ID, Fingerprint, or device credentials.

### ⚡ Silent Secure Storage
Store and retrieve encrypted secrets without displaying biometric prompts when appropriate.

### 🛡️ Security Auditing
Inspect device security status including:
* Root/Jailbreak detection
* Device lock screen configuration
* Biometric enrollment
* Hardware-backed key availability

### 📱 Native Performance
Runs cryptographic operations on native threads with React Native's modern architecture.

---

## 📱 Platform Support

| Platform | Supported |
|-----------|-----------|
| Android | ✅ |
| iOS | ✅ |
| React Native New Architecture | ✅ |
| TypeScript | ✅ |

---

## 📦 Installation

```sh
npm install @hituchhimpa/react-native-auth-vault
# or
yarn add @hituchhimpa/react-native-auth-vault
```

For iOS, install the pods:
```sh
cd ios && pod install
```

---

## ⚙️ Configuration

### iOS Setup (Mandatory)
For Face ID to work on iOS, you **must** add `NSFaceIDUsageDescription` to your application's `ios/YourAppName/Info.plist` file. If this is missing, the app will crash during biometric verification.

```xml
<key>NSFaceIDUsageDescription</key>
<string>This app requires Face ID permission to securely authenticate and access your credentials.</string>
```

### Android Setup
No manual manifest setup is required. The library automatically bundles the required Android Biometric permissions.

---

## 🚀 Usage

### 1. Store & Retrieve with Biometric Protection
Prompt the user for biometrics (Face ID/Touch ID/Fingerprint/Passcode) to unlock access to the stored key:

```typescript
import { AuthVault } from '@hituchhimpa/react-native-auth-vault';

// Save securely with biometrics
await AuthVault.setItem(
  'token',
  jwt,
  'Authenticate to save credentials'
);

// Retrieve securely
const token = await AuthVault.getItem(
  'token',
  'Authenticate to continue'
);
```

### 2. Silent Hardware-Backed Storage (Optional Biometrics)
Encrypt and store keys using hardware cryptoprocessors (Secure Enclave / TEE) **silently** without prompting the user:

```typescript
// Silent hardware-backed encryption
await AuthVault.setItem('api_key', apiKey, '');

const apiKey = await AuthVault.getItem('api_key', '');
```

### 3. Device Security Auditing
Get security metrics to decide whether your app should run or restrict sensitive actions:

```typescript
const security = AuthVault.audit();

if (security.isRooted) {
  console.warn('Untrusted device detected');
}
```

---

## 🔒 Security Architecture

### Android
* Keys generated inside Android Keystore
* StrongBox support where available
* Optional biometric-gated key access
* AES-256 encryption

### iOS
* Keys protected by Secure Enclave
* Keychain Access Control integration
* Face ID / Touch ID protected operations
* User presence verification support

---

## 🚀 Common Use Cases

* Storing JWT access tokens
* Refresh token protection
* API request signing
* Local credential storage
* Banking and fintech applications
* Healthcare applications
* Enterprise authentication workflows

---

## 👤 Author

Developed and maintained by [Hitesh Chhimpa](https://github.com/hituchhimpa7).

---

## 📄 License

MIT

---

<p align="center">Made with ❤️ by <a href="https://github.com/hituchhimpa7">Hitesh Chhimpa</a></p>
