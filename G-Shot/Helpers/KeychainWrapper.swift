//
// Created by Alexey on 5/5/17.
// Copyright (c) 2017 GoTo Inc. All rights reserved.
//

import Foundation

class KeychainWrapper {
    // Supply an optional Keychain access group to access shared Keychain items.
    var accessGroup: String? {
        let accessGroup = Bundle.main.bundleIdentifier
        let appIdPrefix = "LT3MAR5838" //Bundle.main.object(forInfoDictionaryKey: "AppIdentifierPrefix")

        return appIdPrefix + "." + accessGroup!
    }

    /**
   Adds the text value in the keychain.

   - parameter itemKey: Key under which the text value is stored in the keychain.
   - parameter itemValue: Text string to be written to the keychain.
   - returns: True if the text was successfully written to the keychain.

   */
    @discardableResult
    func add(itemKey key: String, itemValue value: String) -> Bool {
        guard let valueData = value.data(using: .utf8) else { return false }

        // Delete the item before adding, otherwise there will be multiple items with the same name
        delete(itemKey: key)

        var queryAdd: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key as AnyObject,
            kSecValueData as String: valueData as AnyObject,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        if let accessGroup = accessGroup {
            queryAdd[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        let resultCode = SecItemAdd(queryAdd as CFDictionary, nil)

        if resultCode != noErr { return false }

        return true
    }

    /**

   Returns a text item from the Keychain.

   - parameter itemKey: The key that is used to read the keychain item.
   - returns: The text value from the keychain. Returns nil if unable to read the item.

    */
    func find(itemKey key: String) -> String? {
        var queryLoad: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key as AnyObject,
                kSecReturnData as String: kCFBooleanTrue,
                kSecMatchLimit as String: kSecMatchLimitOne
        ]
        if let accessGroup = accessGroup {
            queryLoad[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        var result: AnyObject?
        let resultCodeLoad = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
        }
        if resultCodeLoad == noErr, let result = result as? Data {
            if let keyValue = String(data: result, encoding: .utf8) {
                return keyValue
            }
        }

        return nil
    }

    /**

   Deletes the single keychain item specified by the key.

   - parameter itemKey: The key that is used to delete the keychain item.
   - returns: True if the item was successfully deleted.

    */
    @discardableResult
    private func delete(itemKey key: String) -> Bool {
        var queryDelete: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key as AnyObject
        ]
        if let accessGroup = accessGroup {
            queryDelete[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        let resultCodeDelete = SecItemDelete(queryDelete as CFDictionary)

        if resultCodeDelete != noErr { return false }

        return true
    }
}
