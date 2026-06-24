import Foundation

@objc(SecureMemoryStore)
public class SecureMemoryStore: NSObject {

    // Backing store: never exposed to JS / ObjC heap as String
    private static var store: [String: [UInt8]] = [:]
    private static let lock = NSLock()

    @objc
    public static func store(key: String, value: String) {
        let bytes = Array(value.utf8)
        lock.lock()
        store[key] = bytes
        lock.unlock()
    }

    @objc
    public static func read(key: String) -> String? {
        lock.lock()
        defer { lock.unlock() }
        guard let bytes = store[key] else { return nil }
        return String(bytes: bytes, encoding: .utf8)
    }

    @objc
    public static func wipe() {
        lock.lock()
        defer { lock.unlock() }
        // Zero out every byte before removing
        for (key, _) in store {
            if var bytes = store[key] {
                for i in 0..<bytes.count { bytes[i] = 0 }
                store[key] = bytes
            }
        }
        store.removeAll()
    }
}
