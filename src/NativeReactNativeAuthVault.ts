import { TurboModuleRegistry, type TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  audit(): Object;
  encrypt(plainText: string, prompt: string): Promise<string>;
  decrypt(encryptedBase64: string, prompt: string): Promise<string>;
  setItem(key: string, value: string, prompt: string): Promise<boolean>;
  getItem(key: string, prompt: string): Promise<string | null>;
  removeItem(key: string): Promise<boolean>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('ReactNativeAuthVault');
