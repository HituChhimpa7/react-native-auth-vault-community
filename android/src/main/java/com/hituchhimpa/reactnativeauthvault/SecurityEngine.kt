package com.hituchhimpa.reactnativeauthvault

import android.os.Build
import android.os.Debug
import java.io.File

object SecurityEngine {

    fun audit(context: android.content.Context): Map<String, Any> {
        val rooted = isRooted()
        val emulator = isEmulator()
        val debugger = isDebuggerAttached()
        
        val hardwareBacked = context.packageManager.hasSystemFeature("android.hardware.strongbox_keystore")
        val biometricEnabled = androidx.biometric.BiometricManager.from(context).canAuthenticate(androidx.biometric.BiometricManager.Authenticators.BIOMETRIC_STRONG) == androidx.biometric.BiometricManager.BIOMETRIC_SUCCESS

        var score = 100
        if (rooted) score -= 50
        if (emulator) score -= 20
        if (debugger) score -= 20
        if (!hardwareBacked) score -= 10
        if (!biometricEnabled) score -= 5

        return mapOf(
            "secureStorage" to true,
            "hardwareBacked" to hardwareBacked,
            "biometricEnabled" to biometricEnabled,
            "rooted" to rooted,
            "jailbroken" to false,
            "emulator" to emulator,
            "debuggerAttached" to debugger,
            "securityScore" to score
        )
    }

    private fun isRooted(): Boolean {
        val buildTags = Build.TAGS
        if (buildTags != null && buildTags.contains("test-keys")) {
            return true
        }

        val paths = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/su",
            "/su/bin/su"
        )
        for (path in paths) {
            if (File(path).exists()) return true
        }

        return false
    }

    private fun isEmulator(): Boolean {
        return (Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                || "google_sdk" == Build.PRODUCT)
    }

    private fun isDebuggerAttached(): Boolean {
        return Debug.isDebuggerConnected() || Debug.waitingForDebugger()
    }
}
