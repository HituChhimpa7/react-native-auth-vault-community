package com.hituchhimpa.reactnativeauthvault

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.Arguments
import androidx.fragment.app.FragmentActivity

class ReactNativeAuthVaultModule(reactContext: ReactApplicationContext) :
  NativeReactNativeAuthVaultSpec(reactContext) {

  private val cryptoEngine = CryptoEngine(reactContext)

  override fun audit(): WritableMap {
    val map = Arguments.createMap()
    val auditResult = SecurityEngine.audit(reactApplicationContext)
    
    for ((key, value) in auditResult) {
        when (value) {
            is Boolean -> map.putBoolean(key, value)
            is Int -> map.putInt(key, value)
            is Double -> map.putDouble(key, value)
            is String -> map.putString(key, value)
        }
    }
    
    return map
  }

  override fun encrypt(plainText: String, prompt: String, promise: Promise) {
    val activity = currentActivity as? FragmentActivity
    if (activity == null) {
      promise.reject("ERR_ACTIVITY", "Activity is null or not a FragmentActivity")
      return
    }

    cryptoEngine.encrypt(activity, plainText, prompt,
      onSuccess = { encrypted -> promise.resolve(encrypted) },
      onError = { error -> promise.reject("ERR_ENCRYPT", error) }
    )
  }

  override fun decrypt(encryptedBase64: String, prompt: String, promise: Promise) {
    val activity = currentActivity as? FragmentActivity
    if (activity == null) {
      promise.reject("ERR_ACTIVITY", "Activity is null or not a FragmentActivity")
      return
    }

    cryptoEngine.decrypt(activity, encryptedBase64, prompt,
      onSuccess = { decrypted -> promise.resolve(decrypted) },
      onError = { error -> promise.reject("ERR_DECRYPT", error) }
    )
  }

  private fun getSharedPreferences(): android.content.SharedPreferences {
    return reactApplicationContext.getSharedPreferences("ReactNativeAuthVaultStorage", android.content.Context.MODE_PRIVATE)
  }

  override fun setItem(key: String, value: String, prompt: String, promise: Promise) {
    val activity = currentActivity as? FragmentActivity
    if (activity == null) {
      promise.reject("ERR_ACTIVITY", "Activity is null or not a FragmentActivity")
      return
    }

    cryptoEngine.encrypt(activity, value, prompt,
      onSuccess = { encrypted -> 
        getSharedPreferences().edit().putString(key, encrypted).apply()
        promise.resolve(true) 
      },
      onError = { error -> promise.reject("ERR_ENCRYPT", error) }
    )
  }

  override fun getItem(key: String, prompt: String, promise: Promise) {
    val encrypted = getSharedPreferences().getString(key, null)
    if (encrypted == null) {
      promise.resolve(null)
      return
    }

    val activity = currentActivity as? FragmentActivity
    if (activity == null) {
      promise.reject("ERR_ACTIVITY", "Activity is null or not a FragmentActivity")
      return
    }

    cryptoEngine.decrypt(activity, encrypted, prompt,
      onSuccess = { decrypted -> promise.resolve(decrypted) },
      onError = { error -> promise.reject("ERR_DECRYPT", error) }
    )
  }

  override fun removeItem(key: String, promise: Promise) {
    getSharedPreferences().edit().remove(key).apply()
    promise.resolve(true)
  }

  companion object {
    const val NAME = NativeReactNativeAuthVaultSpec.NAME
  }
}
