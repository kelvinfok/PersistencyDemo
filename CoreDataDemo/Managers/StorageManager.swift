//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Kelvin Fok on 7/12/18.
//  Copyright © 2018 kelvinfok. All rights reserved.
//

import Foundation

class StorageManager {
    
    let vault = UserDefaults.standard
    
    enum Key: String {
        case image
    }
    
    func save(data: Data, key: Key) {
        vault.set(data, forKey: key.rawValue)
    }
    
    func retrieve(key: Key) -> Any? {
        return vault.object(forKey: key.rawValue)
    }
}
