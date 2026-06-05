# 🛡️ React Native Auth Vault

[![npm version](https://img.shields.io/npm/v/@hituchhimpa/react-native-auth-vault.svg?style=flat-square)](https://www.npmjs.com/package/@hituchhimpa/react-native-auth-vault)
[![license](https://img.shields.io/badge/license-MIT-green.svg?style=flat-square)](LICENSE)
[![platform](https://img.shields.io/badge/platform-ios%20%7C%20android-blue.svg?style=flat-square)](#)

A premium, native-first security and authentication library for React Native. Provides secure, hardware-backed cryptographic storage and runtime security auditing for enterprise-grade mobile applications.

---

## ✨ Features

* 🔑 **Hardware-Backed Encryption**: Private keys are generated and stored securely inside the **Android Keystore (TEE/StrongBox)** and **iOS Secure Enclave**.
* 👤 **Biometric Protection**: FaceID, TouchID, and Android BiometricPrompt integration with customizable user prompts.
* ⚡ **Optional Biometrics**: Supports both biometric-authenticated operations and high-performance silent hardware encryption (no prompts).
* 🛡️ **Security Auditing**: Run real-time checks to inspect device integrity (e.g. root/jailbreak detection, device passcode setup, biometrics status).
* 🧵 **Thread Safe & Native**: Constructed using React Native's modern architecture, executing complex cryptographic tasks on native threads.

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

// Store a value securely (triggers biometric prompt)
const saveSecureToken = async (token: string) => {
  try {
    const success = await AuthVault.setItem(
      'user_token',
      token,
      'Scan fingerprint to secure your credentials'
    );
    if (success) console.log('Stored securely!');
  } catch (error) {
    console.error('Storage failed:', error);
  }
};

// Retrieve a value (triggers biometric prompt)
const getSecureToken = async () => {
  try {
    const token = await AuthVault.getItem(
      'user_token',
      'Scan fingerprint to access your account'
    );
    console.log('Retrieved Token:', token);
  } catch (error) {
    console.error('Failed to unlock token:', error);
  }
};
```

### 2. Silent Hardware-Backed Storage (Optional Biometrics)
Encrypt and store keys using hardware cryptoprocessors (Secure Enclave / TEE) **silently** without prompting the user. Perfect for API request signing, background session tokens, or caching:

```typescript
// Pass an empty string `""` as the prompt to bypass the biometric UI
const saveSilentToken = async (token: string) => {
  await AuthVault.setItem('api_key', token, '');
};

const getSilentToken = async () => {
  const token = await AuthVault.getItem('api_key', '');
  return token; // Returns the token silently
};
```

### 3. Device Security Auditing
Get security metrics to decide whether your app should run or restrict sensitive actions:

```typescript
const checkDeviceSecurity = () => {
  const audit = AuthVault.audit();
  console.log(audit);
  /* 
    Output:
    {
      isRooted: false,           // Root/Jailbreak status
      hasPin: true,              // Device lock (PIN/Password) setup
      biometricsEnabled: true,   // Biometrics enrollment status
      hardwareBacked: true       // Key storage hardware backing status
    }
  */
};
```

---

## 🛡️ Under the Hood: Security Architecture

Here is how your data is secured at the hardware level:

* **Android Keystore (TEE/StrongBox)**: When biometric auth is enabled, the library generates a 256-bit AES key and locks it behind OS biometric policy requirements (`setUserAuthenticationRequired(true)`). When disabled, the key is generated in hardware but unlocked silently when the device is unlocked.
* **iOS Secure Enclave**: On FaceID-enabled devices, keys are generated inside the physical Secure Enclave. Access is restricted using Keychain Access Control flags (`kSecAttrAccessControl` with `.userPresence`).

---

## 🛠️ API Reference

| Method | Type | Description |
| :--- | :--- | :--- |
| `setItem(key, value, prompt)` | `Promise<boolean>` | Encrypts and saves `value` locally. Pass non-empty `prompt` for biometrics, or `""` for silent encryption. |
| `getItem(key, prompt)` | `Promise<string \| null>` | Decrypts and retrieves `value`. Pass non-empty `prompt` for biometrics, or `""` for silent decryption. |
| `removeItem(key)` | `Promise<boolean>` | Deletes the stored key and encrypted value from device. |
| `encrypt(plainText, prompt)` | `Promise<string>` | Encrypts raw text and returns a base64 cipher payload. |
| `decrypt(base64Text, prompt)` | `Promise<string>` | Decrypts a base64 cipher payload back to plain text. |
| `audit()` | `Object` | Runs security checks on the device hardware and environment. |

---

## 👤 Author

Developed and maintained by [Hitesh Chhimpa](https://github.com/hituchhimpa7).

---

## 📄 License

MIT

---

<p align="center">Made with ❤️ by <a href="https://github.com/hituchhimpa7">Hitesh Chhimpa</a></p>
