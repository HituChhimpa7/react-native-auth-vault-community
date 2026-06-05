import ReactNativeAuthVault from './NativeReactNativeAuthVault';

export const AuthVault = {
  audit: (): Object => ReactNativeAuthVault.audit(),
  encrypt: (plainText: string, prompt: string): Promise<string> => ReactNativeAuthVault.encrypt(plainText, prompt),
  decrypt: (encryptedBase64: string, prompt: string): Promise<string> => ReactNativeAuthVault.decrypt(encryptedBase64, prompt),
  setItem: (key: string, value: string, prompt: string): Promise<boolean> => ReactNativeAuthVault.setItem(key, value, prompt),
  getItem: (key: string, prompt: string): Promise<string | null> => ReactNativeAuthVault.getItem(key, prompt),
  removeItem: (key: string): Promise<boolean> => ReactNativeAuthVault.removeItem(key),
};
