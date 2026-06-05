#import "ReactNativeAuthVault.h"

#if __has_include("react_native_auth_vault/react_native_auth_vault-Swift.h")
#import "react_native_auth_vault/react_native_auth_vault-Swift.h"
#else
#import "react_native_auth_vault-Swift.h"
#endif

@implementation ReactNativeAuthVault {
    CryptoEngine *_cryptoEngine;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cryptoEngine = [[CryptoEngine alloc] init];
        [_cryptoEngine initializeKey];
    }
    return self;
}

- (NSDictionary *)audit {
    return [SecurityEngine audit];
}

- (void)encrypt:(NSString *)plainText prompt:(NSString *)prompt resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    [_cryptoEngine encryptWithPlainText:plainText prompt:prompt completion:^(NSString * _Nullable encryptedBase64, NSString * _Nullable error) {
        if (error) {
            reject(@"ERR_ENCRYPT", error, nil);
        } else {
            resolve(encryptedBase64);
        }
    }];
}

- (void)decrypt:(NSString *)encryptedBase64 prompt:(NSString *)prompt resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    [_cryptoEngine decryptWithEncryptedBase64:encryptedBase64 prompt:prompt completion:^(NSString * _Nullable decryptedText, NSString * _Nullable error) {
        if (error) {
            reject(@"ERR_DECRYPT", error, nil);
        } else {
            resolve(decryptedText);
        }
    }];
}

- (void)setItem:(NSString *)key value:(NSString *)value prompt:(NSString *)prompt resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    [_cryptoEngine encryptWithPlainText:value prompt:prompt completion:^(NSString * _Nullable encryptedBase64, NSString * _Nullable error) {
        if (error) {
            reject(@"ERR_ENCRYPT", error, nil);
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:encryptedBase64 forKey:key];
            resolve(@(YES));
        }
    }];
}

- (void)getItem:(NSString *)key prompt:(NSString *)prompt resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    NSString *encryptedBase64 = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (!encryptedBase64) {
        resolve([NSNull null]);
        return;
    }
    
    [_cryptoEngine decryptWithEncryptedBase64:encryptedBase64 prompt:prompt completion:^(NSString * _Nullable decryptedText, NSString * _Nullable error) {
        if (error) {
            reject(@"ERR_DECRYPT", error, nil);
        } else {
            resolve(decryptedText);
        }
    }];
}

- (void)removeItem:(NSString *)key resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    resolve(@(YES));
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeReactNativeAuthVaultSpecJSI>(params);
}

+ (NSString *)moduleName
{
  return @"ReactNativeAuthVault";
}

@end
