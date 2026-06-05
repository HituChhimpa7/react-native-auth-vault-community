import Foundation
import UIKit
import Darwin

@objc(SecurityEngine)
public class SecurityEngine: NSObject {

    @objc
    public static func audit() -> [String: Any] {
        let jailbroken = isJailbroken()
        let emulator = isEmulator()
        let debugger = isDebuggerAttached()

        let context = LAContext()
        var error: NSError?
        let biometricEnabled = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)

        var score = 100
        if jailbroken { score -= 50 }
        if emulator { score -= 20 }
        if debugger { score -= 20 }
        if !biometricEnabled { score -= 5 }

        return [
            "secureStorage": true,
            "hardwareBacked": true,
            "biometricEnabled": biometricEnabled,
            "rooted": false,
            "jailbroken": jailbroken,
            "emulator": emulator,
            "debuggerAttached": debugger,
            "securityScore": score
        ]
    }

    private static func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        let paths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/usr/bin/ssh"
        ]
        
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        // Try writing to a restricted area
        do {
            let path = "/private/jailbreak_test.txt"
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
        #endif
    }

    private static func isEmulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    private static func isDebuggerAttached() -> Bool {
        var info = kinfo_proc()
        var mib : [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        if junk != 0 {
            return false
        }
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
}
